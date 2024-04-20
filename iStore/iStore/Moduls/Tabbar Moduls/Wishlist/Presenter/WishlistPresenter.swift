import Foundation
import FirebaseFirestore

protocol WishlistPresenterProtocol: AnyObject {
    func viewDidLoad()
    var productCount: Int { get }
    func getProduct(at index: Int) -> Product
}

final class WishlistPresenter: WishlistPresenterProtocol {
    
    weak var view: WishlistVCProtocol?
    var products: [Product] = []
    
    private let db = Firestore.firestore()
    
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
        products = [Product(id: 0, picture: "imgProduct", description: "Earphones for monitor", price: 100, isFavourite: false),
                    Product(id: 1, picture: "imgProduct", description: "Earphones for monitor, but cheaper", price: 99.99, isFavourite: false),
                    Product(id: 3, picture: "imgProduct", description: "Earphones for great look on the street", price: 100, isFavourite: true),
                    Product(id: 4, picture: "imgProduct", description: "Earphones for monitor with great sound and quality", price: 100, isFavourite: false),
                    Product(id: 5, picture: "imgProduct", description: "Earphones for Swift programmer", price: 1000, isFavourite: true),
                    Product(id: 6, picture: "imgProduct", description: "Earphones for Moms and Dads", price: 200, isFavourite: false),
                    Product(id: 7, picture: "imgProduct", description: "Earphones for Windows laptop programmer", price: 100, isFavourite: false),
                    Product(id: 8, picture: "imgProduct", description: "Earphones for poets and designers", price: 100.99, isFavourite: false),
                    Product(id: 9, picture: "imgProduct", description: "Earphones for Mr. Vladimir Dyadichev", price: 100, isFavourite: false),
                    Product(id: 10, picture: "imgProduct", description: "Earphones for best team leader ever", price: 100, isFavourite: false),
                    Product(id: 11, picture: "imgProduct", description: "Earphones for those, who is making Onboarding screens", price: 100, isFavourite: false)
        ]
    }
    func saveProductToFavorites(product: Product) {
        // Обновление данных в Firestore
        guard let index = products.firstIndex(where: { $0.id == product.id }) else { return }
        products[index] = product // Обновляем модель данных
        let docRef = db.collection("products").document(product.id!.description)
        docRef.setData([
            "isFavourite": product.isFavourite ?? false
        ], merge: true) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated")
                self.view?.reloadCollectionView() // Обновляем представление после успешного сохранения
            }
        }
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
        let product = products[index]
        
        // Получение идентификатора продукта
        guard let productId = product.id else { return }
        
        let docRef = db.collection("products").document(productId.description)
        
        docRef.getDocument { [weak self] (document, error) in
            guard let self = self else { return }
            
            if let document = document, document.exists {
                // Если документ существует, то продукт уже в избранном, удаляем его
                docRef.delete { error in
                    if let error = error {
                        print("Error removing product: \(error)")
                    } else {
                        print("Product successfully removed from favorites")
                    }
                    // Обновляем представление после удаления
                    self.view?.reloadCollectionView()
                }
            } else {
                // Если документ не существует, то продукт еще не в избранном, добавляем его
                let data: [String: Any] = [
                    "isFavourite": true // Устанавливаем значение true, так как добавляем в избранное
                ]
                docRef.setData(data) { error in
                    if let error = error {
                        print("Error adding document: \(error)")
                    } else {
                        print("Document successfully added to favorites")
                    }
                    // Обновляем представление после добавления
                    self.view?.reloadCollectionView()
                }
            }
        }
    }
}
