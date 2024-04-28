import UIKit

protocol SearchVCProtocol: AnyObject {
    func reloadCollectionView()
    func updateTableView(with results: [SingleProduct])
}

final class SearchVC: UIViewController, SearchVCProtocol {
    var presenter: SearchPresenter!
    

    // MARK: UI Elements
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: presenter.isProductCellVisible ? 170 : UIScreen.main.bounds.width,
                                         height: presenter.isProductCellVisible ? 217 : 25)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        let padding: CGFloat = 10
        layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        return collectionView
    }()

    private let searchBar = SearchBarView()

    private let emptyResponseLabel = UILabel.makeLabel(text: "Sorry, couldn't find \n anything 😢",
                                                   font: UIFont.InterRegular(ofSize: 18),
                                                   textColor: UIColor.darkGray,
                                                   numberOfLines: 2,
                                                   alignment: .center)

    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.hideKeyboard()
        presenter = SearchPresenter(viewController: self)
        configureCollectionView()
        setViews()
        setupUI()
        setSearchBar()
      
    }

    // MARK: Private Methods
    private func setSearchBar() {
        let frame = CGRect(x: 55, y: 0, width: 250, height: 44)
        let titleView = UIView(frame: frame)
        searchBar.frame = frame
        titleView.addSubview(searchBar)
        navigationItem.titleView = titleView
        searchBar.delegate = self
        searchBar.secondDelegate = self 
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Buy"),
                                                            style: .plain, target: self,
                                                            action: #selector(buyButtonPressed))
        navigationController?.navigationBar.tintColor = UIColor.black
    }
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SingleItemCell.self,
                                forCellWithReuseIdentifier: SingleItemCell.identifier)
        collectionView.register(EmptySearchCell.self,
                                forCellWithReuseIdentifier: EmptySearchCell.identifier)
//        collectionView.register(EmptyHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView")
//        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderViewTwo")
        collectionView.register(EmptyHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: EmptyHeaderView.identifier)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.identifier)
    }

    func reloadCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    func updateTableView(with results: [SingleProduct]) {
           if presenter.products.isEmpty {
               print ("nothing found")
               emptyResponseLabel.isHidden = false
           }
           collectionView.reloadData()
       }

    // MARK: Selector Methods
    @objc func buyButtonPressed() {}

}

extension SearchVC {
    func setViews() {
        [collectionView, emptyResponseLabel].forEach { view.addSubview($0)}
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        emptyResponseLabel.isHidden = true
    }
    func setupUI() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            emptyResponseLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyResponseLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }


}

extension SearchVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if presenter.isProductCellVisible {
            return presenter.productCount
        } else {
            return presenter.queryCount
        }

    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if presenter.isProductCellVisible  {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SingleItemCell.identifier, for: indexPath) as! SingleItemCell
            let product = presenter.getProduct(at: indexPath.item)
            self.emptyResponseLabel.isHidden = true
            cell.configure(with: product)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptySearchCell.identifier, for: indexPath) as! EmptySearchCell
            let product = presenter.getQuery(at: indexPath.row)
            self.emptyResponseLabel.isHidden = true
            cell.set(info: product)
            cell.delegate = self
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        let product = presenter.getProduct(at: indexPath.item)
        guard let productId = product.id else { return }
        NetworkingManager.shared.getProduct(for: productId) { result in
            switch result {
            case .success(let resultProducts):
                DispatchQueue.main.async {
                    let vc = DetailsVC(data: resultProducts)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print("Error fetching search results: \(error)")
            }

            }
        }




    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

            return CGSize(width: collectionView.frame.width, height: 30)

    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if presenter.isProductCellVisible {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.identifier, for: indexPath) as! HeaderView
            return header
        } else {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: EmptyHeaderView.identifier, for: indexPath) as! EmptyHeaderView
            header.delegate = self
            return header
        }
    }
}

extension SearchVC: SearchBarViewDelegate, SearchBarForSearchVCDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter.isProductCellVisible = false
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: collectionView.frame.width, height: 25)
        }

        collectionView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       guard let searchText = searchBar.text else { return }
        (collectionView.visibleSupplementaryViews(ofKind: UICollectionView.elementKindSectionHeader).first as? HeaderView)?.searchlabel.text = "Search result for '\(searchText)'"
        if searchText.isEmpty {
            presenter.isProductCellVisible = false
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.itemSize = CGSize(width: collectionView.frame.width, height: 25)
            }
        } else {

            presenter.isProductCellVisible = true
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.itemSize = CGSize(width: 170, height: 217)
            }
            presenter.searchData(searchText: searchText)
       }
        collectionView.reloadData()
        presenter.userDefaultsManager.searchHistoryForEmptySearchScreen.append(searchText)
    }

}

extension SearchVC: SearchCellDelegate, EmptyHeaderViewDelegate {
    func clearButtonPressed() {
        presenter.clearButtonPressed()
    }
    
    func closeButtonPressed(for cell: EmptySearchCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        presenter.closeButtonPressed(forProductAt: indexPath)
    }
}
