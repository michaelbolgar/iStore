import UIKit
import FirebaseFirestore
import Firebase

protocol ProfileViewProtocol: AnyObject {
    func updateProfile(with name: String, email: String, imageUrl: String?)
    func updateProfileImage(_ image: UIImage)
    func navigateToLoginScreen()
    func showSignOutError(_ error: Error)
    func imageUploadCompleted()
}

final class ProfileVC: UIViewController {
    var presenter: ProfilePresenterProtocol!
    
    // MARK: - UI Elements
    private let profileTitle = UILabel.makeLabel(text: "Profile",
                                                 font: .InterBold(ofSize: 24),
                                                 textColor: .customDarkGray,
                                                 numberOfLines: nil,
                                                 alignment: .center)
    
    private lazy var profileImage: UIImageView = {
        let element = UIImageView()
        element.image = UIImage(named: "profilePhoto")
        element.layer.cornerRadius = 65
        element.clipsToBounds = true
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private let profileName = UILabel.makeLabel(text: "",
                                                font: .InterSemiBold(ofSize: 20),
                                                textColor: .customDarkGray,
                                                numberOfLines: 1,
                                                alignment: .left)
    
    private let profileEmail = UILabel.makeLabel(text: "",
                                                 font: .InterSemiBold(ofSize: 14),
                                                 textColor: .customLightGray,
                                                 numberOfLines: 1,
                                                 alignment: .left)
    
    private lazy var settingsProfileButton: UIButton = {
        let element = UIButton(type: .system)
        element.setBackgroundImage(UIImage(systemName: "gearshape.2"), for: .normal)
        element.backgroundColor = .white
        element.tintColor = .customDarkGray
        element.addTarget(self, action: #selector(settingsProfileButtonTapped), for: .touchUpInside)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    
    private lazy var changePhotoProfileButton: UIButton = {
        let element = UIButton(type: .system)
        element.setBackgroundImage(UIImage(systemName: "square.and.pencil.circle.fill"), for: .normal)
        element.layer.borderColor = UIColor.white.cgColor
        element.layer.borderWidth = 3
        element.layer.cornerRadius = 17
        element.backgroundColor = .white
        element.addTarget(self, action: #selector(changePhotoProfileButtonTapped), for: .touchUpInside)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private let typeAccountView = UIView.makeGreyButton(textLabel: "Type of account",
                                                        textColor: .customDarkGray,
                                                        nameMarker: "chevron.forward",
                                                        colorMarker: .customDarkGray)
    
    private let termsView = UIView.makeGreyButton(textLabel: "Terms & Conditions",
                                                  textColor: .customDarkGray,
                                                  nameMarker: "chevron.forward",
                                                  colorMarker: .customDarkGray)
    
    private let signoutView = UIView.makeGreyButton(textLabel: "Sign Out",
                                                    textColor: .customDarkGray,
                                                    nameMarker: "arrow.forward.to.line.square",
                                                    colorMarker: .customDarkGray)
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        fetchUserProfile()
        presenter = ProfilePresenter(view: self)
        presenter.fetchProfileData()
    }
    
    //MARK: Private Methods
    private func setupViews() {
        
        view.backgroundColor = .white
        
        view.hideKeyboard() // это нужно для реализации функции по изменению логина и почты
        
        [profileTitle, settingsProfileButton, profileImage, profileName, profileEmail, changePhotoProfileButton, typeAccountView, termsView, signoutView].forEach { view.addSubview($0) }
        
        //добавляем рекогнайзер на кнопки(вью)
        typeAccountView.isUserInteractionEnabled = true
        termsView.isUserInteractionEnabled = true
        signoutView.isUserInteractionEnabled = true
        
        let typeAccountTapGesture = UITapGestureRecognizer(target: self, action: #selector(typeAccountViewTapped))
        typeAccountView.addGestureRecognizer(typeAccountTapGesture)
        
        let termsTapGesture = UITapGestureRecognizer(target: self, action: #selector(termsViewTapped))
        termsView.addGestureRecognizer(termsTapGesture)
        
        let signoutTapGesture = UITapGestureRecognizer(target: self, action: #selector(signoutViewTapped))
        signoutView.addGestureRecognizer(signoutTapGesture)
        
    }
    
    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                print("Failed to load image from URL: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            DispatchQueue.main.async {
                print("Image successfully loaded from URL")
                self.profileImage.image = image
            }
        }.resume()
    }
    
    private func fetchUserProfile() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            return
        }
        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                self.updateUI(with: document.data())
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func updateUI(with userData: [String: Any]?) {
        DispatchQueue.main.async {
            self.profileName.text = userData?["login"] as? String ?? "Name not available"
            self.profileEmail.text = userData?["email"] as? String ?? "Email not available"
            
            if let imageUrlString = userData?["profileImageUrl"] as? String {
                print("Image URL String: \(imageUrlString)")
                if let imageUrl = URL(string: imageUrlString) {
                    print("Loading image from URL: \(imageUrl)")
                    self.loadImage(from: imageUrl)
                } else {
                    print("Invalid URL string for image")
                    self.profileImage.image = UIImage(named: "profilePhoto") // Загрузка изображения по умолчанию, если URL недоступен
                }
            } else {
                print("No image URL found")
                self.profileImage.image = UIImage(named: "defaultProfilePhoto")
            }
        }
    }
    
    // MARK: Selector Methods
    @objc private func settingsProfileButtonTapped() {
        print("settingsProfile button tapped")
    }
    
    @objc private func changePhotoProfileButtonTapped() {
        let changePhotoVC = ChangePhotoViewController()
        changePhotoVC.modalPresentationStyle = .automatic
        present(changePhotoVC, animated: true, completion: nil)
    }
    
    @objc private func typeAccountViewTapped() {
        let changePhotoVC = ChangeProfileViewController()
        changePhotoVC.modalPresentationStyle = .automatic
        present(changePhotoVC, animated: true, completion: nil)
    }
    
    @objc private func termsViewTapped() {
        print("terms button tapped")
        let termsVC = TermsViewController()
        termsVC.modalTransitionStyle = .coverVertical
        present(termsVC, animated: true, completion: nil)
    }
    
    @objc private func signoutViewTapped() {
        presenter.signOut()
    }
}

// MARK: - Setup Constraints
private extension ProfileVC {
    
    func setupConstraints() {
        // Определение константы для удобства
        let inset: CGFloat = 20
        
        NSLayoutConstraint.activate([
            
            profileTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            settingsProfileButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            settingsProfileButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 92),
            profileImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: inset),
            profileImage.widthAnchor.constraint(equalToConstant: 130),
            profileImage.heightAnchor.constraint(equalToConstant: 130),
            
            changePhotoProfileButton.widthAnchor.constraint(equalToConstant: 34),
            changePhotoProfileButton.heightAnchor.constraint(equalToConstant: 34),
            changePhotoProfileButton.trailingAnchor.constraint(equalTo: profileImage.trailingAnchor),
            changePhotoProfileButton.bottomAnchor.constraint(equalTo: profileImage.bottomAnchor),
            
            profileName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 104),
            profileName.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor, constant: 150),
            profileName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            profileName.heightAnchor.constraint(equalToConstant: 24),
            
            profileEmail.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 128),
            profileEmail.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor, constant: 150),
            profileEmail.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            profileEmail.heightAnchor.constraint(equalToConstant: 24),
            
            typeAccountView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            typeAccountView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            typeAccountView.bottomAnchor.constraint(equalTo: termsView.bottomAnchor, constant: -84),
            
            termsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            termsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            termsView.bottomAnchor.constraint(equalTo: signoutView.bottomAnchor, constant: -84),
            
            signoutView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            signoutView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            signoutView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -124)
        ])
    }
}

extension ProfileVC: ProfileViewProtocol {
    
    func showSignOutError(_ error: any Error) {
        print(error.localizedDescription)
    }
    
    func navigateToLoginScreen() {
        //        RootRouter.shared.showLoginNavigationController()
    }
    
    func updateProfile(with name: String, email: String, imageUrl: String?) {
        profileName.text = name
        profileEmail.text = email
        if let imageUrl = imageUrl, let url = URL(string: imageUrl) {
            loadImage(from: url)
        } else {
            profileImage.image = UIImage(named: "profilePhoto")
        }
    }
    func updateProfileImage(_ image: UIImage) {
        DispatchQueue.main.async {
            self.profileImage.image = image
        }
    }
    func imageUploadCompleted() {
        presenter.fetchProfileData() // Refetch profile data after image upload completion
    }
}

