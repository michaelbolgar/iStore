import Foundation

protocol WishlistPresenterProtocol: AnyObject {
    func viewDidLoad()
    var productCount: Int { get }
    func getProduct(at index: Int) -> Product
}

final class WishlistPresenter: WishlistPresenterProtocol {
    
    weak var view: WishlistVCProtocol?
    var products: [Product] = []
    
    init(viewController: WishlistVC? = nil) {
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
                    Product(picture: "imgProduct", description: "Earphones for monitor", price: 100, isFavourite: false),
                    Product(picture: "imgProduct", description: "Earphones for monitor", price: 100, isFavourite: true),
                    Product(picture: "imgProduct", description: "Earphones for monitor", price: 100, isFavourite: false),
                    Product(picture: "imgProduct", description: "Earphones for monitor", price: 100, isFavourite: true),
                    Product(picture: "imgProduct", description: "Earphones for monitor", price: 100, isFavourite: false),
                    Product(picture: "imgProduct", description: "Earphones for monitor", price: 100, isFavourite: false),
                    Product(picture: "imgProduct", description: "Earphones for monitor", price: 100.99, isFavourite: false),
                    Product(picture: "imgProduct", description: "Earphones for monitor", price: 100, isFavourite: false),
                    Product(picture: "imgProduct", description: "Earphones for monitor", price: 100, isFavourite: false),
                    Product(picture: "imgProduct", description: "Earphones for monitor", price: 100, isFavourite: false)
        ]
    }
}

//MARK: - WishCollectionCellDelegate
extension WishlistPresenter: WishCollectionCellDelegate {
    func buyButtonPressed() {
        print("Buy pressed")
    }
    
    func heartButtonPressed() {
        print("Heart pressed")
        
    }
}
