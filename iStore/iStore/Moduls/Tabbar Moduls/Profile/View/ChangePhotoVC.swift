import UIKit
import FirebaseStorage
import Firebase

protocol ChangePhotoViewProtocol: AnyObject {
    func imageUploadCompleted()
    func imageUploadFailed(with error: Error)
}

final class ChangePhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var presenter: ChangePhotoPresenterProtocol!
    var delegate: ProfileViewProtocol!
    
    // MARK: - UI Elements
    private lazy var containerView: UIView = {
        let element = UIView()
        element.backgroundColor = .white
        element.layer.cornerRadius = 12
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var titleLabel: UILabel = {
        let element = UILabel()
        element.text = "Change your Picture"
        element.font = .systemFont(ofSize: 20, weight: .bold)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private let takePhotoView = UIView.makeGreyButton(textLabel: "Take a Photo",
                                                      textColor: .customDarkGray,
                                                      nameMarker: "camera",
                                                      colorMarker: .customDarkGray)
    
    private let chooseFromFileView = UIView.makeGreyButton(textLabel: "Choose from Your Files",
                                                           textColor: .customDarkGray,
                                                           nameMarker: "folder",
                                                           colorMarker: .customDarkGray)
    
    private let deletePhotoView = UIView.makeGreyButton(textLabel: "Delete Photo",
                                                        textColor: .customRed,
                                                        nameMarker: "trash.fill",
                                                        colorMarker: .customRed)
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        #warning("почему этот презентер не давал обновлять фотку в режиме реального времени?")
//        presenter = ChangePhotoPresenter()
    }
    
    // MARK: - Private Methods
    private func setupViews() {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        
        [blurView, containerView].forEach { view.addSubview($0) }
        
        [titleLabel, takePhotoView, chooseFromFileView, deletePhotoView].forEach { containerView.addSubview($0) }
        
        setupGestureRecognizers()
    }
    
    private func setupGestureRecognizers() {
        takePhotoView.isUserInteractionEnabled = true
        chooseFromFileView.isUserInteractionEnabled = true
        deletePhotoView.isUserInteractionEnabled = true
        
        takePhotoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(takePhotoViewTapped)))
        chooseFromFileView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseFromFileViewTapped)))
        deletePhotoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deletePhotoViewTapped)))
    }
    
    // MARK: - Selector Methods
    @objc private func takePhotoViewTapped() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true)
        }
    }
    
    @objc private func chooseFromFileViewTapped() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true)
        }
    }
    
    @objc private func deletePhotoViewTapped() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let storageRef = Storage.storage().reference().child("profile_images/\(userId).jpg")
        storageRef.delete { error in
            if let error = error {
                print("Error removing the image: \(error)")
            } else {
                print("Image successfully removed")
                // Optionally update Firestore or local data to reflect no image
            }
        }
    }
    
    // MARK: UIImagePickerControllerDelegate
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            presenter.uploadImage(editedImage)
        } else if let originalImage = info[.originalImage] as? UIImage {
            presenter.uploadImage(originalImage)
        }
        dismiss(animated: true)
    }
    
    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true) {
                    self.delegate?.imageUploadCompleted() // Notify the delegate
                }
    }
    
    
    // MARK: - Image Handling
    private func updateProfileImage(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.4),
              let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let storageRef = Storage.storage().reference().child("profile_images/\(userId).jpg")
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            guard let _ = metadata else {
                print("Failed to upload image: \(error?.localizedDescription ?? "no error info")")
                return
            }
            storageRef.downloadURL { url, error in
                guard let downloadURL = url else {
                    print("Download URL not found")
                    return
                }
                print("Image uploaded and URL updated in Firestore: \(downloadURL)")
                // Update Firestore or send URL back to delegate
            }
        }
    }
    
    // MARK: - Setup Constraints
    func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 350),
            containerView.heightAnchor.constraint(equalToConstant: 300),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            takePhotoView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            takePhotoView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            takePhotoView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            chooseFromFileView.topAnchor.constraint(equalTo: takePhotoView.bottomAnchor, constant: 10),
            chooseFromFileView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            chooseFromFileView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            deletePhotoView.topAnchor.constraint(equalTo: chooseFromFileView.bottomAnchor, constant: 10),
            deletePhotoView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            deletePhotoView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20)
        ])
    }
}

extension ChangePhotoViewController: ChangePhotoViewProtocol {
    func imageUploadCompleted() {
        dismiss(animated: true, completion: nil)
    }
    
    func imageUploadFailed(with error: Error) {
        print("Error uploading image: \(error.localizedDescription)")
        // Optionally show an alert to the user
    }
}



