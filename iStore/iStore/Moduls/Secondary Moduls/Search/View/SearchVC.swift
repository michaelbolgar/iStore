import UIKit

protocol SearchVCProtocol: AnyObject {
    func reloadCollectionView()
    func updateTableView(with results: [SingleProduct])
}

final class SearchVC: UIViewController, SearchVCProtocol {
    func updateTableView(with results: [SingleProduct]) {
        collectionView.reloadData()
    }
    

    var presenter: SearchPresenter!

    // MARK: UI Elements

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: presenter.showSection1 ? 170 : UIScreen.main.bounds.width,
                                         height: presenter.showSection1 ? 217 : 25)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        let padding: CGFloat = 10
        layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        return collectionView
    }()

    private let searchBar = SearchBarView()

    private let searchlabel = UILabel.makeLabel(text: "Search result for",
                                                font: UIFont.InterRegular(ofSize: 14),
                                                textColor: UIColor.customDarkGray,
                                                numberOfLines: 1,
                                                alignment: .left)
    
    private let filterView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 5
        view.layer.borderColor = UIColor.veryLightGray.cgColor
        return view
    }()

    private let filterlabel = UILabel.makeLabel(text: "Filters",
                                                font: UIFont.InterRegular(ofSize: 12),
                                                textColor: UIColor.customDarkGray,
                                                numberOfLines: 1,
                                                alignment: .left)
    
    private let imageFilter: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Filter")
        return image
    }()
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.hideKeyboard()
        presenter = SearchPresenter(viewController: self)
        presenter.getData()
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
        collectionView.register(SearchCollectionCell.self,
                                forCellWithReuseIdentifier: SearchCollectionCell.identifier)
        collectionView.register(EmptySearchCell.self,
                                forCellWithReuseIdentifier: EmptySearchCell.identifier)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView")
    }


    func reloadCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    // MARK: Selector Methods
    @objc func buyButtonPressed() {}

}

extension SearchVC {
    func setViews() {
        [collectionView, searchlabel, filterView].forEach { view.addSubview($0)}
        filterView.addSubview(filterlabel)
        filterView.addSubview(imageFilter)
        searchlabel.translatesAutoresizingMaskIntoConstraints = false
        filterView.translatesAutoresizingMaskIntoConstraints = false
        filterlabel.translatesAutoresizingMaskIntoConstraints = false
        imageFilter.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupUI() {
        NSLayoutConstraint.activate([
            searchlabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchlabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 117),

            filterView.widthAnchor.constraint(equalToConstant: 78),
            filterView.heightAnchor.constraint(equalToConstant: 27),
            filterView.centerYAnchor.constraint(equalTo: searchlabel.centerYAnchor),
            filterView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            filterlabel.centerYAnchor.constraint(equalTo: filterView.centerYAnchor),
            filterlabel.leadingAnchor.constraint(equalTo: filterView.leadingAnchor, constant: 8),

            imageFilter.heightAnchor.constraint(equalToConstant: 12),
            imageFilter.widthAnchor.constraint(equalToConstant: 12),
            imageFilter.trailingAnchor.constraint(equalTo: filterView.trailingAnchor, constant: -8),
            imageFilter.centerYAnchor.constraint(equalTo: filterView.centerYAnchor),

            collectionView.topAnchor.constraint(equalTo: filterView.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }


}

extension SearchVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return presenter.showSection1 ? 1 : 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if presenter.showSection1 {
            return presenter.productCount
            } else {
                return section == 0 ? 0 : presenter.queryCount
            }
        }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if presenter.showSection1  {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionCell.identifier, for: indexPath) as! SearchCollectionCell
            let product = presenter.getProduct(at: indexPath.item)
            cell.set(info: product)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptySearchCell.identifier, for: indexPath) as! EmptySearchCell
            let product = presenter.getQuery(at: indexPath.row)
            cell.set(info: product)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if presenter.showSection1 || section == 0 {
            return .zero
        } else {
            return CGSize(width: collectionView.frame.width, height: 20)
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if kind == UICollectionView.elementKindSectionHeader  {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath) as! HeaderView
                return headerView
        }
        fatalError("Unexpected element kind")
    }
}

extension SearchVC: SearchBarViewDelegate, SearchBarForSearchVCDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("sdg")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {}

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        searchlabel.text = "Search result for '\(searchText)'"
        if searchText.isEmpty {
            presenter.showSection1 = false
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.itemSize = CGSize(width: collectionView.frame.width, height: 25)
            }
        } else {
            presenter.showSection1 = true
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.itemSize = CGSize(width: 170, height: 217)
            }
            presenter.searchData(searchText: searchText)
        }
        collectionView.reloadData()
      
    }

}

