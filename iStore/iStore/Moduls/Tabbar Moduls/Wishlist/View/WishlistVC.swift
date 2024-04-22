import UIKit

protocol WishlistVCProtocol: AnyObject {
    func reloadCollectionView()
}

final class WishlistVC: UIViewController, WishlistVCProtocol {
    
    var presenter: WishlistPresenter!

    // MARK: UI Elements
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.createTwoColumnFlowLayout(in: view)
        
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    private let searchBar = SearchBarView()
    
    // MARK: Life cycle
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setPresenter()
        configureCollectionView()
        setViews()
        setupUI()
        hideLeftNavigationItem()
        setupSearchBar()
    }
    
    // MARK: Private Methods
    private func setupSearchBar() {
#warning("Изменить реализацию searchBar. Вероятно уйти от фреймов и navigationBar")
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
        collectionView.register(WishCollectionCell.self,
                                forCellWithReuseIdentifier: WishCollectionCell.identifier)
    }
    
    func reloadCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    // MARK: Selector Methods
    @objc func cartButtonPressed() {
        // go to cart screen
    }
    
}

//MARK: - Extensions
//MARK: Setup
extension WishlistVC {
    func setViews() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setPresenter() {
        presenter = WishlistPresenter(viewController: self)
        presenter.viewDidLoad()
    }

    func setupUI() {
        view.backgroundColor = .white
        #warning ("Клавиатура не убирается по тапу")
        view.hideKeyboard()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.cart,
                                                            style: .plain, target: self,
                                                            action: #selector(cartButtonPressed))
        navigationController?.navigationBar.tintColor = UIColor.black
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

//MARK: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension WishlistVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.productCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WishCollectionCell.identifier, for: indexPath) as! WishCollectionCell
        let product = presenter.getProduct(at: indexPath.item)
        cell.set(info: product, at: indexPath.item)
        cell.delegate = presenter
        return cell
    }
}

//MARK: SearchBarViewDelegate
extension WishlistVC: SearchBarViewDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      print(searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        print(searchText)
    }
}
