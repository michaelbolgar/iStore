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
        self.startListeningForFavoritesUpdates()
    }

    // MARK: Methods

    func getProduct(at index: Int) -> Product {
        return products[index]
    }
    
    var listenerRegistration: ListenerRegistration?

    func startListeningForFavoritesUpdates() {
        listenerRegistration?.remove()  // Удаляем предыдущий слушатель, если он есть
        guard let userId = Auth.auth().currentUser?.uid else {
            print("UID пользователя не доступен.")
            return
        }
        let favoritesCollection = db.collection("users").document(userId).collection("favorites")

        listenerRegistration = favoritesCollection.addSnapshotListener { [weak self] (snapshot, error) in
            guard let self = self else { return }
            if let error = error {
                print("Ошибка при обновлении данных: \(error)")
                return
            }

            guard let snapshot = snapshot else {
                print("Данные снимка не доступны.")
                return
            }
            self.products = snapshot.documents.compactMap { document -> Product? in
                let data = document.data()
                let id = Int(document.documentID)  // Проверьте, что ID документа можно преобразовать в Int
                let picture = data["picture"] as? String
                let description = data["description"] as? String
                let price = (data["price"] as? NSNumber)?.doubleValue
                let isFavourite = data["isFavorite"] as? Bool
                return Product(id: id, picture: picture, description: description, price: price, isFavourite: isFavourite)
            }
//            self.view?.reloadCollectionView()
        }
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
                print("Ошибка получения документов: \(err)")
            } else {
                self.products = querySnapshot?.documents.compactMap { document -> Product? in
                    let data = document.data()
                    let id = Int(document.documentID) // Преобразуем ID
                    let title = data["title"] as? String
                    let description = data["description"] as? String
                    let price = (data["price"] as? NSNumber)?.doubleValue
                    let images = data["images"] as? [String]
                    let isFavourite = data["isFavorite"] as? Bool
                    return Product(id: id, picture: images?.first, description: description, price: price, isFavourite: isFavourite)
                } ?? []
//                self.view?.reloadCollectionView()
            }
        }
    }
    func reloadData() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let favoritesCollection = db.collection("users").document(userId).collection("favorites")
        
        favoritesCollection.getDocuments { [weak self] (snapshot, error) in
            guard let self = self else { return }
            if let error = error {
                print("Ошибка при обновлении данных: \(error)")
                return
            }
            
            guard let snapshot = snapshot else { return }
            self.products = snapshot.documents.compactMap { document -> Product? in
                let data = document.data()
                let id = Int(document.documentID) // Преобразуем ID
                let picture = data["picture"] as? String
                let description = data["description"] as? String
                let price = (data["price"] as? NSNumber)?.doubleValue
                let isFavourite = data["isFavorite"] as? Bool
                return Product(id: id, picture: picture, description: description, price: price, isFavourite: isFavourite)
            }
//            self.view?.reloadCollectionView() // Обновляем UI
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
            }
        }
    }
}
