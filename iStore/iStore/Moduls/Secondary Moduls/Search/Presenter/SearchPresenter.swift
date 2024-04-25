import Foundation

struct LastSearchData {
    let enteredWord: String?
}

protocol SearchPresenterProtocol: AnyObject {
    func getData()
    var productCount: Int { get }
    func getProduct(at index: Int) -> Product
}

final class SearchPresenter: SearchPresenterProtocol {
    weak var view: SearchVCProtocol?
    var products: [Product] = []
    var emptyQuery: [LastSearchData] = []
    var showSection1 = false

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

    func getProduct(at index: Int) -> Product {
        return products[index]
    }
    func getData() {
        products = [Product(id: 1, picture: "imgProduct", description: "Earphones for monitor", price: 100),
                    Product(id: 1, picture: "imgProduct", description: "Earphones for monitor", price: 100),
                    Product(id: 1, picture: "imgProduct", description: "Earphones for monitor", price: 100),
                    Product(id: 1, picture: "imgProduct", description: "Earphones for monitor", price: 100),
                    Product(id: 1, picture: "imgProduct", description: "Earphones for monitor", price: 100),
                    Product(id: 1, picture: "imgProduct", description: "Earphones for monitor", price: 100)
]
        emptyQuery = [LastSearchData(enteredWord: "Iphone 12 pro max"),
                 LastSearchData(enteredWord: "Iphone 12 pro max"),
                 LastSearchData(enteredWord: "Iphone 12 pro max")
        ]
    }
}
