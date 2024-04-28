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
        collectionView.register(EmptyHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView")
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderViewTwo")
    }

    func reloadCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    func updateTableView(with results: [SingleProduct]) {
        collectionView.reloadData()
    }

    // MARK: Selector Methods
    @objc func buyButtonPressed() {}

}

extension SearchVC {
    func setViews() {
        [collectionView].forEach { view.addSubview($0)}
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    func setupUI() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
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
            cell.set(info: product)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptySearchCell.identifier, for: indexPath) as! EmptySearchCell
            let product = presenter.getQuery(at: indexPath.row)
            cell.set(info: presenter.userDefaultsManager.searchHistoryForEmptySearchScreen[indexPath.row])
            cell.delegate = self
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

            return CGSize(width: collectionView.frame.width, height: 30)

    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if presenter.isProductCellVisible {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderViewTwo", for: indexPath) as! HeaderView
            return header
        } else {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath) as! EmptyHeaderView
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
