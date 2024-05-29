import Foundation

// MARK: - Protocol
protocol HomePresenterProtocol {

    var categoryData: [Category] { get }
    var showedProducts: [SingleProduct] { get }
    
    func showCartVC()
    func showSearchVC(searchText: String)
    func showDetailsVC(data: SingleProduct)
    func showFilterVC()
    func updateSortingCriteria(option: SortingOption)
    func updatePriceRange(minPrice: Double?, maxPrice: Double?)

    func setCategories()
    func setProducts(for id: Int)
}

// MARK: - Class
final class HomePresenter: HomePresenterProtocol {

    // MARK: - Properties
    weak var view: HomeVCProtocol?
    private let router: HomeRouterProtocol

    var categoryData: [Category] = []
    private var productData: [SingleProduct] = []
    var showedProducts: [SingleProduct] = []
    private var minPrice: Double?
        private var maxPrice: Double?

    init(view: HomeVCProtocol, router: HomeRouterProtocol) {
        self.view = view
        self.router = router
    }

    // MARK: - Methods
    func setCategories() {
        NetworkingManager.shared.getCategories { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let categories):
                    self?.categoryData = categories
                    self?.view?.reloadData(with: 1)
                case .failure(let error):
                    print("Error fetching collections: \(error)")
                }
            }
        }
    }

    func setProducts(for id: Int) {
        NetworkingManager.shared.getProductsByCategory(for: id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let products):
                    self?.productData = products
                    self?.showedProducts = products
                    print(products)
                    self?.view?.reloadData(with: 2)
                case .failure(let error):
                    print("Error fetching: \(error)")
                }
            }
        }
    }

    func showCartVC() {
        router.showCartVC()
    }

    func showSearchVC(searchText: String) {
        router.showSearchVC(searchText: searchText)
    }

    func showDetailsVC(data: SingleProduct) {
        router.showDetailsVC(data: data)
    }

    func showFilterVC() {
        showedProducts = productData
        router.showFilterVC(delegate: self)
    }
}


// MARK: - Extensions
extension HomePresenter: FilterPresenterDelegate {
    func transferData(_ data: String) {
        print(data)
    }
    
    func updateSortingCriteria(option: SortingOption) {
        switch option {
        case .title:
            showedProducts.sort { $0.title ?? "" < $1.title ?? "" }
        case .priceLow:
            showedProducts.sort { $0.price ?? 0 < $1.price ?? 0 }
        case .priceHigh:
            showedProducts.sort { $0.price ?? 0 > $1.price ?? 0 }
        }
        view?.reloadData(with: 2)
    }
    
    func updatePriceRange(minPrice: Double?, maxPrice: Double?) {
        if let minPrice = minPrice {
            showedProducts = productData.filter({ item in
                return Double(item.price ?? 0) >= minPrice
            })
        }
        if let maxPrice = maxPrice {
            showedProducts = productData.filter({ item  in
                return Double(item.price ?? 0) <= maxPrice
            })
        }
        view?.reloadData(with: 2)
    }
}

