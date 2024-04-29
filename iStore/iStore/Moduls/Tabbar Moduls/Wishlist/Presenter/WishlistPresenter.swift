import Foundation
import FirebaseFirestore
import Firebase

protocol WishlistPresenterProtocol: AnyObject {
    var productCount: Int { get }
    func getProduct(at index: Int) -> Product
    func showCartVC()
    func showDetailsVC(data: SingleProduct)
    func viewDidLoad()
}

final class WishlistPresenter: WishlistPresenterProtocol {
    
    weak var view: WishlistVCProtocol?
    private let router: WishlistRouterProtocol
    private let db = Firestore.firestore()

    var products: [Product] = []

    var productCount: Int {
        return products.count
    }

    // MARK: Init

    init(view: WishlistVCProtocol, router: WishlistRouterProtocol) {
        self.view = view
        self.router = router
    }

    // MARK: Methods

    func getProduct(at index: Int) -> Product {
        return products[index]
    }

//    func setView() {
//        products = [Product(id: 0, picture: "imgProduct", description: "Earphones for monitor", price: 100, isFavourite: false),
//                    Product(id: 1, picture: "imgProduct", description: "Earphones for monitor, but cheaper", price: 99.99, isFavourite: false),
//                    Product(id: 2, picture: "imgProduct", description: "Earphones for great look on the street", price: 100, isFavourite: true),
//                    Product(id: 3, picture: "imgProduct", description: "Earphones for monitor with great sound and quality", price: 100, isFavourite: false),
//                    Product(id: 4, picture: "imgProduct", description: "Earphones for Swift programmer", price: 1000, isFavourite: true),
//                    Product(id: 5, picture: "imgProduct", description: "Earphones for Moms and Dads", price: 200, isFavourite: false),
//                    Product(id: 6, picture: "imgProduct", description: "Earphones for Windows laptop programmer", price: 100, isFavourite: false),
//                    Product(id: 7, picture: "imgProduct", description: "Earphones for poets and designers", price: 100.99, isFavourite: false),
//                    Product(id: 8, picture: "imgProduct", description: "Earphones for Mr. Vladimir Dyadichev", price: 100, isFavourite: false),
//                    Product(id: 9, picture: "imgProduct", description: "Earphones for best team leader ever", price: 100, isFavourite: false),
//                    Product(id: 10, picture: "imgProduct", description: "Earphones for those, who is making Onboarding screens", price: 100, isFavourite: false)
//        ]
//    }

    func showCartVC() {
        router.showCartVC()
    }

    func showDetailsVC(data: SingleProduct) {
        router.showDetailsVC(data: data)
    }
    
    func viewDidLoad() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let favoritesCollection = db.collection("users").document(userId).collection("favorites")
        
        favoritesCollection.getDocuments { [weak self] (querySnapshot, err) in
            guard let self = self else { return }
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.products = querySnapshot?.documents.compactMap { document -> Product? in
                    let data = document.data()
                    let id = Int(document.documentID) // Attempt to convert the string ID to Int
                    let picture = data["picture"] as? String
                    let description = data["description"] as? String
                    let price = (data["price"] as? NSNumber)?.doubleValue // Use NSNumber to handle any numeric type
                    let isFavourite = data["isFavourite"] as? Bool
                    return Product(id: id, picture: picture, description: description, price: price, isFavourite: isFavourite)
                } ?? []
                self.view?.reloadCollectionView()
            }
        }
    }

}

//MARK: - WishCollectionCellDelegate
extension WishlistPresenter: WishCollectionCellDelegate {
    func buyButtonPressed() {
        print("add to cart pressed")
    }
    
    func heartButtonPressed(at index: Int) {
        guard let userId = Auth.auth().currentUser?.uid,
              products.indices.contains(index),
              let productId = products[index].id else { return }
        products[index].isFavourite?.toggle()
        
        let docRef = db.collection("users").document(userId).collection("favorites").document(productId.description)
        
        docRef.getDocument { [weak self] (document, error) in
            guard let self = self else { return }
            
            if let document = document, document.exists {
                // Удаляем из избранного
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
                // Добавляем в избранное
                let data: [String: Any] = [
                    "isFavourite": true
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
