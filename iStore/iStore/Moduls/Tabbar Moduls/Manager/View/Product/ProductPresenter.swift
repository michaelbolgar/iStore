

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
        products = [Product(id: 123, picture: "imgProduct", description: "Earphones for monitor", price: 100, isFavourite: false),
                    Product(id: 1234, picture: "imgProduct", description: "Earphones for monitor, but cheaper", price: 99.99, isFavourite: false)
        ]
    }
}

//MARK: - WishCollectionCellDelegate
extension ProductPresenter: ProductCollectionCellDelegate {
    func deleteButtonPressed() {
        print("delete pressed")
    }
    
    func updateButtonPressed() {
        print("update pressed")
    }
}
