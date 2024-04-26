import Foundation

protocol HomePresenterProtocol: AnyObject {
    func viewDidLoad()
    func getData()
    func getProduct(at index: Int) -> SingleProduct
}

final class HomePresenter: HomePresenterProtocol {

    //    weak var view: HomeVCProtocol?
    weak var viewController:  HomeVCProtocol?
    private var service = NetworkingManager.shared
    var products: [SingleProduct] = []
    var categories: [Category] = []

    init(viewController: HomeVCProtocol) {
        self.viewController = viewController
    }
    
    func viewDidLoad() {
        getCategories()

    }
    
    var productCount: Int {
        return products.count
    }

    func getProduct(at index: Int) -> SingleProduct {
        return products[index]
    }
    func getData() {

    }
    
    private func getCategories() {
        service.getCategories { [weak self] result in
            switch result {
            case let .success(resultRequest):
                self?.viewController?.show(category: resultRequest)
            case let .failure(error):
                print(error.localizedDescription)
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
                    self.viewController?.updateCollectionView(with: searchResults)
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
