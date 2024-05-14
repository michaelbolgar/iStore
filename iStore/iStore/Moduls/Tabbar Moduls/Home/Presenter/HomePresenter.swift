import Foundation

protocol HomePresenterProtocol {

    var categoryData: [Category] { get }
    var productData: [SingleProduct] { get }

    func showCartVC()
    func showSearchVC(searchText: String)
    func showDetailsVC(data: SingleProduct)
    func showFilterVC()
    func updateSortingCriteria(option: SortingOption)

    func setCategories()
    func setProducts(for id: Int)
}

final class HomePresenter: HomePresenterProtocol {

    weak var view: HomeVCProtocol?
    private let router: HomeRouterProtocol

    var categoryData: [Category] = []
    var productData: [SingleProduct] = []


    init(view: HomeVCProtocol, 
         router: HomeRouterProtocol)
    {
        self.view = view
        self.router = router
    }

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
        router.showFilterVC(delegate: self)
    }
    
//    func updateSortingCriteria(option: SortingOption) {
//        switch option {
//        case .title:
//            productData.sort { $0.title ?? "" < $1.title ?? "" }
//        case .priceLow:
//            productData.sort { $0.price ?? 0 < $1.price ?? 0 }
//        case .priceHigh:
//            productData.sort { $0.price ?? 0 > $1.price ?? 0 }
//        }
//        view?.reloadData(with: 2)
//    }
}

extension HomePresenter: FilterPresenterDelegate {
    func transferData(_ data: String) {
        print(data)
    }
    func updateSortingCriteria(option: SortingOption) {
        switch option {
        case .title:
            productData.sort { $0.title ?? "" < $1.title ?? "" }
        case .priceLow:
            productData.sort { $0.price ?? 0 < $1.price ?? 0 }
        case .priceHigh:
            productData.sort { $0.price ?? 0 > $1.price ?? 0 }
        }
        view?.reloadData(with: 2)
    }
}
