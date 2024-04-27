import Foundation

protocol HomePresenterProtocol {
    init(view: HomeVCProtocol/*, router: HomeRouterProtocol*/)
    var products: [SingleProduct] { get }
    var categories: [Category] { get }
    var productCount: Int { get }
    
    func viewDidLoad()
    func getCategories(at index: Int) -> Category
    func getProduct(at index: Int) -> SingleProduct
    func getCount(at section: Int)
    func getCategories()
    func getProduct(for id: Int)
    func searchData(searchText: String)

}

final class HomePresenter: HomePresenterProtocol {
    
    
    init(view: HomeVCProtocol/*, router: HomeRouterProtocol*/) {
        self.view = view
        //        self.router = router
        return
    }
    
    
    weak var view:  HomeVCProtocol?
    //    private var router: HomeRouterProtocol
    
    private var service = NetworkingManager.shared
    var products: [SingleProduct] = []
    var categories: [Category] = []
    let sections: [Section] = []

//    init(viewController: HomeVCProtocol? = nil) {
//        self.view = viewController
//    }
    
    func viewDidLoad() {
//        getCategories()
    }
    

    func getCategories(at index: Int) -> Category {
        return categories[index]
    }
    
    func getProduct(at index: Int) -> SingleProduct {
        return products[index]
    }
    
    var productCount: Int {
        return products.count
    }
    
    
    func getCount(at section: Int) {
        switch section {
        case 1:
            categories.count
        case 2:
            products.count
        default:
            0
        }
    }
    
    
    func getCategories() {
        service.getCategories { [weak self] result in
            switch result {
            case let .success(categories):
                print("Info about product: \(categories)")
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getProduct(for id: Int) {
        service.getProduct(for: id) { [weak self]  result in
            switch result {
            case .success(let product):
                print("Info about product: \(product)")
            case .failure(let error):
                print("Error fetching collections: \(error)")
            }
        }
    }
    
    func searchData(searchText: String) {
        service.doSearch(for: searchText) { [ weak self ] result in
            guard let self = self else { return }
            switch result {
            case .success(let searchResults):
                DispatchQueue.main.async {
                    self.products = searchResults
                    self.view?.updateCollectionView(with: searchResults)
                    print(self.products)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print(error)
                }
            }
        }
    }
}
