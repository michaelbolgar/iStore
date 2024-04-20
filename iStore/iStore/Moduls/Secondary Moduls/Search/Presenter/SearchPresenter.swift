import Foundation

protocol SearchPresenterProtocol: AnyObject {
    func getData()
    var productCount: Int { get }
    func getProduct(at index: Int) -> Product
}

final class SearchPresenter: SearchPresenterProtocol {
       weak var view: SearchVCProtocol?
    var products: [Product] = []

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
     products = [Product(picture: "imgProduct", description: "Earphones for monitor", price: 100),
            Product(picture: "imgProduct", description: "Earphones for monitor", price: 100),
            Product(picture: "imgProduct", description: "Earphones for monitor", price: 100),
            Product(picture: "imgProduct", description: "Earphones for monitor", price: 100),
            Product(picture: "imgProduct", description: "Earphones for monitor", price: 100),
            Product(picture: "imgProduct", description: "Earphones for monitor", price: 100)
]
    }
}
