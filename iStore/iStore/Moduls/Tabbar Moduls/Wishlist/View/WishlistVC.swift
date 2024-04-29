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
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let searchBar = SearchBarView()
    
    private lazy var cartButton: UIButton = {
        let element = UIButton()
        element.setBackgroundImage(UIImage(named: "Buy"), for: .normal)
        element.addTarget(self, action: #selector(cartButtonPressed), for: .touchUpInside)
        element.translatesAutoresizingMaskIntoConstraints = false
//        element.contentMode = .scaleAspectFit
        return element
    }()
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setPresenter()
        configureCollectionView()
        setViews()
        setupUI()
        hideLeftNavigationItem()
        setupSearchBar()
        checkCollectionState()
    }
    
    // MARK: Private Methods
    // Initial code commented by Qew through
    //    private func setupSearchBar() {
    //#warning("Изменить реализацию searchBar. Вероятно уйти от фреймов и navigationBar")
    //        let frame = CGRect(x: 0, y: 0, width: 300, height: 40)
    //        let titleView = UIView(frame: frame)
    //        searchBar.frame = frame
    //        titleView.addSubview(searchBar)
    //        navigationItem.titleView = titleView
    //        searchBar.delegate = self
    //    }
    
    
    // SearchBar out of the navigationBar fix 1.01
    private func setupSearchBar() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.backgroundColor = .white
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
        presenter.showCartVC()
        cartButton.tappingAnimation()
    }
}

//MARK: - Extensions
//MARK: Setup
extension WishlistVC {
    func setViews() {
        view.addSubview(cartButton)
        view.addSubview(searchBar)
        view.addSubview(collectionView)
    }
    
    func setPresenter() {
        presenter.setView()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        view.hideKeyboard()
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 12),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            cartButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            cartButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor),
            cartButton.heightAnchor.constraint(equalToConstant: 28),
            cartButton.widthAnchor.constraint(equalToConstant: 28),

            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            searchBar.trailingAnchor.constraint(equalTo: cartButton.leadingAnchor, constant: -10),
            searchBar.heightAnchor.constraint(equalToConstant: 56)
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

// Screen state if the collection View is empty
#warning ("Check with working DB. Move to Presenter?")
extension WishlistVC {
    func checkCollectionState() {
        // Check if the collection view is empty
        let emptyImageView = UIImageView(image: UIImage(named: "bookmark"))
        let emptyCollectionLabel = UILabel.makeLabel(text: "No saved items yet", font: UIFont.InterMedium(ofSize: 20), textColor: .black, numberOfLines: 2, alignment: .center)
        
        if collectionView.numberOfItems(inSection: 0) == 0 {
            // Collection view is empty, show the image in the center
            emptyImageView.contentMode = .scaleAspectFit
            emptyImageView.translatesAutoresizingMaskIntoConstraints = false
            emptyCollectionLabel.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(emptyImageView)
            view.addSubview(emptyCollectionLabel)
            
            NSLayoutConstraint.activate([
                emptyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                emptyImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                emptyImageView.heightAnchor.constraint(equalToConstant: 200),
                emptyImageView.widthAnchor.constraint(equalToConstant: 200),
                
                emptyCollectionLabel.topAnchor.constraint(equalTo: emptyImageView.bottomAnchor, constant: 10),
                emptyCollectionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        } else {
            // Collection view has data, hide the image if previously shown
            emptyImageView.removeFromSuperview()
            emptyCollectionLabel.removeFromSuperview()
            collectionView.reloadData()
        }
    }
}
