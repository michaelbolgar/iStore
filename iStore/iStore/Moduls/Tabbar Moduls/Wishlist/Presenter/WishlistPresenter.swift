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
                    Product(picture: "imgProduct", description: "Earphones for monitor, but cheaper", price: 99.99, isFavourite: false),
                    Product(picture: "imgProduct", description: "Earphones for great look on the street", price: 100, isFavourite: true),
                    Product(picture: "imgProduct", description: "Earphones for monitor with great sound and quality", price: 100, isFavourite: false),
                    Product(picture: "imgProduct", description: "Earphones for Swift programmer", price: 1000, isFavourite: true),
                    Product(picture: "imgProduct", description: "Earphones for Moms and Dads", price: 200, isFavourite: false),
                    Product(picture: "imgProduct", description: "Earphones for Windows laptop programmer", price: 100, isFavourite: false),
                    Product(picture: "imgProduct", description: "Earphones for poets and designers", price: 100.99, isFavourite: false),
                    Product(picture: "imgProduct", description: "Earphones for Mr. Vladimir Dyadichev", price: 100, isFavourite: false),
                    Product(picture: "imgProduct", description: "Earphones for best team leader ever", price: 100, isFavourite: false),
                    Product(picture: "imgProduct", description: "Earphones for those, who is making Onboarding screens", price: 100, isFavourite: false)
        ]
    }
}

//MARK: - WishCollectionCellDelegate
extension WishlistPresenter: WishCollectionCellDelegate {
    func buyButtonPressed() {
        print("Buy pressed")
    }
    
    func heartButtonPressed(at index: Int) {
            guard products.indices.contains(index) else { return }
            products[index].isFavourite?.toggle()
            view?.reloadCollectionView()
        }
}
