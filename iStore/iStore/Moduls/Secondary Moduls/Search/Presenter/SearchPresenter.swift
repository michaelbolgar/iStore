import Foundation



protocol SearchPresenterProtocol: AnyObject {
    var productCount: Int { get }
    func getProduct(at index: Int) -> SingleProduct
}

final class SearchPresenter: SearchPresenterProtocol {
    weak var view: SearchVCProtocol?
    var products: [SingleProduct] = []
    var isProductCellVisible = true
    let userDefaultsManager = UserDefaultsManager()

    var queryCount: Int {
        return userDefaultsManager.searchHistoryForEmptySearchScreen.count
    }

    func getQuery(at index: Int) -> String  {
        return userDefaultsManager.searchHistoryForEmptySearchScreen[index]
    }

    init(viewController: SearchVC? = nil) {
        self.view = viewController
    }
    var productCount: Int {
        return products.count
    }

    func getProduct(at index: Int) -> SingleProduct {
        return products[index]
    }
    func searchData(searchText: String) {
        NetworkingManager.shared.doSearch(for: searchText) { [ weak self ] result in
            guard let self = self else { return }
            switch result {
            case .success(let searchResults):
                DispatchQueue.main.async {
                    self.products = searchResults
                    self.view?.updateTableView(with: searchResults)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print(error)
                }
            }
        }
    }
    func closeButtonPressed(forProductAt indexPath: IndexPath) {
        userDefaultsManager.searchHistoryForEmptySearchScreen.remove(at: indexPath.item)
         view?.reloadCollectionView()
     }

    func clearButtonPressed() {
        userDefaultsManager.searchHistoryForEmptySearchScreen.removeAll()
        view?.reloadCollectionView()
    }
}
