import Foundation

protocol HomePresenterProtocol {

    var categoryData: [Category] { get }
    var productData: [SingleProduct] { get }

    func showCartVC()
    func showSearchVC(with request: String)
    func showDetailsVC(data: SingleProduct)

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
        print ("and here")
        router.showCartVC()
    }

    func showSearchVC(with request: String) {
        // code
    }

    func showDetailsVC(data: SingleProduct) {
        router.showDetailsVC(data: data)
    }
    func showFilterVC() {
        
    }
}

extension HomePresenter: SingleItemCellDelegate {
    
    func buyButtonPressed() {
        print("Buy pressed")
    }
}
