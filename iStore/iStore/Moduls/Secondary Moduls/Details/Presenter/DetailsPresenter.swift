import Foundation
import UIKit
import Firebase
import FirebaseAuth

protocol DetailsPresenterProtocol {
    func getData(with data: [SingleProduct])
    func showPaymentVC()
    func showCartVC()
    func toggleFavorite(for product: SingleProduct)
    func checkIfProductIsFavorite(_ product: SingleProduct, completion: @escaping (Bool) -> Void)
}

final class DetailsPresenter: DetailsPresenterProtocol {
    
    weak var view: DetailsVCProtocol?
    
    private let db = Firestore.firestore()
    
    init(view: DetailsVCProtocol? = nil) {
        self.view = view
    }
    
    
    // MARK: Methods
    func getData(with data: [SingleProduct]) {
        self.view?.displayDetails()
    }
    
    func toggleFavorite(for product: SingleProduct) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let productId = product.id?.description ?? "defaultId"
        let docRef = db.collection("users").document(userId).collection("favorites").document(productId)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                // Удаляем продукт из избранного
                docRef.delete() { error in
                    if let error = error {
                        print("Ошибка при удалении из избранного: \(error)")
                    } else {
                        print("Продукт успешно удален из избранного")
                    }
                }
            } else {
                // Добавляем продукт в избранное
                let data: [String: Any] = [
                    "title": product.title ?? "",
                    "description": product.description ?? "",
                    "price": product.price ?? 0,
                    "images": product.images,
                    "isFavorite": true
                ]
                docRef.setData(data) { error in
                    if let error = error {
                        print("Ошибка при добавлении в избранное: \(error)")
                    } else {
                        print("Продукт успешно добавлен в избранное")
                    }
                }
            }
        }
    }
    
    func showPaymentVC() {
        let paymentVC = PaymentVC()
        //        self.navigationController?.pushViewController(paymentVC, animated: true)
    }
    
    func showCartVC() {
        // code
    }
}

extension DetailsPresenter {
    func checkIfProductIsFavorite(_ product: SingleProduct, completion: @escaping (Bool) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid, let productId = product.id else {
            completion(false)
            return
        }
        let docRef = db.collection("users").document(userId).collection("favorites").document(String(productId))

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}


