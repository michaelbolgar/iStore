import Foundation

struct LastSearchData {
    let enteredWord: String?
}

protocol SearchPresenterProtocol: AnyObject {
    func getData()
    var productCount: Int { get }
    func getProduct(at index: Int) -> SingleProduct
}

final class SearchPresenter: SearchPresenterProtocol {
    weak var view: SearchVCProtocol?
    var products: [SingleProduct] = []
    var emptyQuery: [LastSearchData] = []
    var showSection1 = true

    var queryCount: Int {
        return emptyQuery.count
    }

    func getQuery(at index: Int) -> LastSearchData {
        return emptyQuery[index]
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
    func getData() {
        emptyQuery = [LastSearchData(enteredWord: "Iphone 12 pro max"),
                 LastSearchData(enteredWord: "Iphone 12 pro max"),
                 LastSearchData(enteredWord: "Iphone 12 pro max")
        ]
    }
    func searchData(searchText: String) {
        NetworkingManager.shared.doSearch(for: searchText) { [ weak self ] result in
            guard let self = self else { return }
            switch result {
            case .success(let searchResults):
                DispatchQueue.main.async {
                    self.products = searchResults
                    self.view?.updateTableView(with: searchResults)
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
