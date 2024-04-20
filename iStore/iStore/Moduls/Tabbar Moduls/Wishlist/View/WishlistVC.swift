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
        view.backgroundColor = .white
        view.hideKeyboard()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.cart,
                                                            style: .plain, target: self,
                                                            action: #selector(cartButtonPressed))
        navigationController?.navigationBar.tintColor = UIColor.black
        presenter = WishlistPresenter(viewController: self)
        presenter.viewDidLoad()
        configureCollectionView()
        setViews()
        setupUI()
        setupSearchBar()
    }
    
    // MARK: Private Methods
    private func setupSearchBar() {
        let frame = CGRect(x: 55, y: 0, width: 270, height: 44)
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

    func setupUI() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
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
