import Foundation

protocol HomePresenterProtocol {

    var categoryData: [Category] { get }
    var productData: [SingleProduct] { get }

    func showCartVC()
    func showSearchVC(with request: String)
    func showDetailsVC(with id: Int)

    func setCategories()
    func setProducts(for id: Int)
}

final class HomePresenter: HomePresenterProtocol {

    weak var view: HomeVCProtocol?
    private let router: HomeRouterProtocol
//    private let networkingManager: NetworkingManager

    var categoryData: [Category] = []
    var productData: [SingleProduct] = []


    init(view: HomeVCProtocol, 
         router: HomeRouterProtocol)
    {
        self.view = view
        self.router = router
//        self.networkingManager = networkingManager
    }

    func setCategories() {
        NetworkingManager.shared.getCategories { result in
            switch result {

            case .success(let categories):
                self.categoryData = categories
//                print(self.categoryData)

            case .failure(let error):
                print("Error fetching collections: \(error)")
            }
        }
    }

    func setProducts(for id: Int) {
        NetworkingManager.shared.getProductsByCategory(for: id) { result in
            switch result {

            case .success(let products):
                self.productData = products
//                print(self.productData)

            case .failure(let error):
                print("Error fetching: \(error)")
            }
        }
    }

    func showCartVC() {
        // code
    }

    func showSearchVC(with request: String) {
        // code
    }

    func showDetailsVC(with id: Int) {
        // code
    }
}
