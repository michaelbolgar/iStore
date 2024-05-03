import UIKit

protocol ProductVCProtocol: AnyObject {
    //func reloadCollectionView()
    func updateTableView(with results: [SingleProduct])
}

final class ProductVC: UIViewController, ProductVCProtocol {
    
    func updateTableView(with results: [SingleProduct]) {
        collectionView.reloadData()
    }
    
    var presenter: ProductPresenter!
    var presenterManager: ManagerPresenterProtocol!
    let shared = NetworkingManager.shared
    
    // MARK: UI Elements
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.createTwoColumnFlowLayout(in: view)
        
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    private let searchBar = SearchBarView()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setPresenter()
        configureCollectionView()
        setupViews()
        
        hideLeftNavigationItem()
        setupSearchBar()
        setupConstraints()
        
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        view.backgroundColor = .white
        view.hideKeyboard()
        
        setNavigationBar(title: "Product")
        navigationController?.isNavigationBarHidden = false
        
        view.addSubview(collectionView)
        view.addSubview(searchBar)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.customDarkGray, NSAttributedString.Key.font: UIFont.InterBold(ofSize: 18)]
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                            style: .plain, target: self,
                                                            action: #selector(addNewProductButtonTapped))
        navigationItem.leftBarButtonItem?.tintColor = .customDarkGray
        navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    private func setPresenter() {
        presenter = ProductPresenter(viewController: self)
        //presenter.viewDidLoad()
    }
    
    private func setupSearchBar() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.backgroundColor = .white
        searchBar.delegate = self
        
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ProductCollectionCell.self,
                                forCellWithReuseIdentifier: ProductCollectionCell.identifier)
    }
    
    //    func reloadCollectionView() {
    //        DispatchQueue.main.async {
    //            self.collectionView.reloadData()
    //        }
    //    }
    
    // MARK: - Selector Methods
    @objc func addNewProductButtonTapped() {
        presenter.addNewProduct()
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension ProductVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.productCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionCell.identifier, for: indexPath) as! ProductCollectionCell
        let product = presenter.getProduct(at: indexPath.item)
        cell.set(info: product, at: indexPath.item)
        cell.presenter = presenter // Устанавливаем делегата ячейке
        cell.product = product
        cell.delegate = presenter
        return cell
    }
}

//MARK: - SearchBarViewDelegate
extension ProductVC: SearchBarViewDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        presenter.fetchProductsByCategory(searchText: (searchText))
        }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        print(searchText)
    }
}

// MARK: - Setup Conctraints
extension ProductVC {
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
