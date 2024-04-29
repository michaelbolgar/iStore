import UIKit
import FirebaseStorage
import FirebaseFirestore
import Firebase
import FirebaseAuth

protocol ProfilePresenterProtocol: AnyObject {
    func fetchProfileData()
    func imageUrlUpdated(_ url: String)
    func signOut()
    func showChangePhotoVC()
}

class ProfilePresenter {

    // MARK: Properties

    weak var view: ProfileViewProtocol?
    internal var router: ProfileRouterProtocol

    private let db = Firestore.firestore()
    private let storage = Storage.storage().reference()
    private let auth = Auth.auth()

    // MARK: Init

    init(view: ProfileViewProtocol, router: ProfileRouterProtocol) {
        self.view = view
        self.router = router
    }
}

// MARK: Extension ProfilePresenterProtocol
extension ProfilePresenter: ProfilePresenterProtocol {
    func showChangePhotoVC() {
        router.showChangePhotoVC()
    }
    
    func fetchProfileData() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            self.view?.navigateToLoginScreen()
            return
        }
        
        db.collection("users").document(userId).getDocument { [weak self] (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let name = data?["login"] as? String ?? "Name not available"
                let email = data?["email"] as? String ?? "Email not available"
                let imageUrl = data?["profileImageUrl"] as? String
                self?.view?.updateProfile(with: name, email: email, imageUrl: imageUrl)
            } else {
                print("Document does not exist")
                self?.view?.navigateToLoginScreen()
            }
        }
    }
    
    func imageUrlUpdated(_ url: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(userId).updateData(["profileImageUrl": url]) { error in
            if let error = error {
                print("Failed to update image URL: \(error.localizedDescription)")
            } else {
                print("Image URL successfully updated.")
                self.fetchProfileData()
            }
        }
    }
    
    func signOut() {
        do {
            try auth.signOut()
            if Auth.auth().currentUser == nil {
                print("Log out tapped")

            }
            view?.navigateToLoginScreen()
        } catch let signOutError {
            view?.showSignOutError(signOutError)
        }
    }
}
