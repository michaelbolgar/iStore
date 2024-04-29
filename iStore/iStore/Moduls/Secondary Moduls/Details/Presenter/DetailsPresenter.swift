import Foundation
import UIKit
import Firebase
import FirebaseAuth

protocol DetailsPresenterProtocol {
    func getData(with data: [SingleProduct])
    func showPaymentVC()
    func showCartVC()
    func toggleFavorite(for product: SingleProduct)
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
        let productId = product.id
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let docRef = db.collection("users").document(userId).collection("favorites").document(productId?.description ?? "")
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                docRef.delete() { error in
                    if let error = error {
                        print("Error removing product from favorites: \(error)")
                    } else {
                        print("Product successfully removed from favorites")
                    }
                }
            } else {
                docRef.setData(["isFavorite": true]) { error in
                    if let error = error {
                        print("Error adding product to favorites: \(error)")
                    } else {
                        print("Product successfully added to favorites")
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


