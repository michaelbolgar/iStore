
//  ChangePhotoPresenter.swift
//  iStore
//
//  Created by Nikita Shirobokov on 25.04.24.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

protocol ChangePhotoPresenterProtocol: AnyObject {
    func uploadImage(_ image: UIImage)
}

protocol ChangePhotoPresenterDelegate: AnyObject {
    func imageDidUpdate(url: String)
}

class ChangePhotoPresenter: ChangePhotoPresenterProtocol {
    weak var view: ChangePhotoViewProtocol?
    private let storage = Storage.storage().reference()
    weak var delegate: ChangePhotoPresenterDelegate?

    func uploadImage(_ image: UIImage) {

        print("check: ChangePhotoPresenter works")

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

                let db = Firestore.firestore()
                db.collection("users").document(userId).updateData(["profileImageUrl": downloadURL.absoluteString]) { error in
                    if let error = error {
                        self?.view?.imageUploadFailed(with: error)
                    } else {
                        self?.delegate?.imageDidUpdate(url: downloadURL.absoluteString)
                        self?.view?.imageUploadCompleted()
                    }
                }
            }
        }
    }
}
