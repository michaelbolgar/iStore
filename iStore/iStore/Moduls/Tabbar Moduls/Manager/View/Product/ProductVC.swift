import UIKit

protocol ProductVCProtocol: AnyObject {
    func reloadCollectionView()
}

final class ProductVC: UIViewController, ProductVCProtocol {
    
    var presenter: ProductPresenter!

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
        setupConstraints()
        hideLeftNavigationItem()
        setupSearchBar()
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        view.backgroundColor = .white
        view.hideKeyboard()
    
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.add,
                                                            style: .plain, target: self,
                                                            action: #selector(goToCategoryVCButtonPressed))
        navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    private func setPresenter() {
        presenter = ProductPresenter(viewController: self)
        presenter.viewDidLoad()
    }

    
    private func setupSearchBar() {
        let frame = CGRect(x: 0, y: 0, width: 300, height: 40)
        let titleView = UIView(frame: frame)
        searchBar.frame = frame
        titleView.addSubview(searchBar)
        navigationItem.titleView = titleView
        searchBar.delegate = self
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ProductCollectionCell.self,
                                forCellWithReuseIdentifier: ProductCollectionCell.identifier)
    }
    
    func reloadCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - Selector Methods
    @objc func goToCategoryVCButtonPressed() {
        // go to cart screen
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
        cell.delegate = presenter
        return cell
    }
}

//MARK: - SearchBarViewDelegate
extension ProductVC: SearchBarViewDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      print(searchText)
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
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
