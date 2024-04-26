import UIKit
import FirebaseStorage
import FirebaseFirestore
import Firebase
import FirebaseAuth

protocol ProfilePresenterProtocol: AnyObject {
    func fetchProfileData()
    func updateProfileImage(_ image: UIImage)
    func imageUrlUpdated(_ url: String)
    func signOut()
}

protocol ChangePhotoPresenterProtocol: AnyObject {
    func uploadImage(_ image: UIImage)
}

class ChangePhotoPresenter: ChangePhotoPresenterProtocol {
    weak var view: ChangePhotoViewProtocol?
    var profilePresenter: ProfilePresenterProtocol?
    private let storage = Storage.storage().reference()
    
    init(view: ChangePhotoViewProtocol) {
        self.view = view
    }
    
    func uploadImage(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.4),
              let userId = Auth.auth().currentUser?.uid else { return }
        
        let storageRef = storage.child("profile_images/\(userId).jpg")
        storageRef.putData(imageData, metadata: nil) { [weak self] metadata, error in
            guard let _ = metadata else {
                self?.view?.imageUploadFailed(with: error ?? NSError())
                return
            }
            storageRef.downloadURL { [weak self] url, error in
                guard let downloadURL = url else {
                    self?.view?.imageUploadFailed(with: error ?? NSError())
                    return
                }
                
                // Обновление URL изображения в Firestore
                let db = Firestore.firestore()
                db.collection("users").document(userId).updateData(["profileImageUrl": downloadURL.absoluteString]) { error in
                    if let error = error {
                        print("Error updating document: \(error.localizedDescription)")
                    } else {
                        print("Document successfully updated")
                        self?.view?.imageUploadCompleted()
                    }
                }
            }
        }
    }
}

class ProfilePresenter: ProfilePresenterProtocol {
    
    weak var view: ProfileViewProtocol?
    private let db = Firestore.firestore()
    private let storage = Storage.storage().reference()
    private let auth = Auth.auth()
    
    init(view: ProfileViewProtocol) {
        self.view = view
    }
    
    func fetchProfileData() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not logged in")
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
            }
        }
    }
    
    func updateProfileImage(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.4),
              let userId = Auth.auth().currentUser?.uid else { return }
        
        let storageRef = storage.child("profile_images/\(userId).jpg")
        storageRef.putData(imageData, metadata: nil) { [weak self] metadata, error in
            guard metadata != nil else {
                print("Failed to upload image: \(error?.localizedDescription ?? "no error info")")
                return
            }
            storageRef.downloadURL { url, error in
                guard let downloadURL = url else {
                    AlertService.shared.showAlert(title: "Error", message: "Download URL not found")
                    return
                }
                self?.view?.updateProfileImage(image)
                self?.imageUrlUpdated(downloadURL.absoluteString)
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
                print("SignOut")
                
            }
            view?.navigateToLoginScreen()
        } catch let signOutError {
            view?.showSignOutError(signOutError)
        }
    }
}
