import Foundation
import FirebaseFirestore
import Firebase

protocol WishlistPresenterProtocol: AnyObject {
    func viewDidLoad()
    var productCount: Int { get }
    func getProduct(at index: Int) -> Product
    //    func toggleFavorite(at index: Int)
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
        print("Buy pressed")
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
