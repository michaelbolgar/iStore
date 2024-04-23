

import Foundation

protocol ProductPresenterProtocol: AnyObject {
    func viewDidLoad()
    var productCount: Int { get }
    func getProduct(at index: Int) -> Product
}

final class ProductPresenter: ProductPresenterProtocol {
    
    weak var view: ProductVCProtocol?
    var products: [Product] = []
    
    init(viewController: ProductVC? = nil) {
        self.view = viewController
    }
    var productCount: Int {
        return products.count
    }
    
    func getProduct(at index: Int) -> Product {
        return products[index]
    }
    
    func viewDidLoad() {
        products = [Product(picture: "imgProduct", description: "Earphones for monitor", price: 100, isFavourite: false),
                    Product(picture: "imgProduct", description: "Earphones for monitor, but cheaper", price: 99.99, isFavourite: false),
                    Product(picture: "imgProduct", description: "Earphones for great look on the street", price: 100, isFavourite: true),
                    Product(picture: "imgProduct", description: "Earphones for monitor with great sound and quality", price: 100, isFavourite: false),
        ]
    }
}

//MARK: - WishCollectionCellDelegate
extension ProductPresenter: ProductCollectionCellDelegate {
    func deleteButtonPressed() {
        print("Buy pressed")
    }
    
    func updateButtonPressed() {
        print("update pressed")
    }
}
