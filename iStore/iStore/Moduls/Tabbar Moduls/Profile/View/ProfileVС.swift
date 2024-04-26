import UIKit
import FirebaseFirestore
import Firebase

protocol ProfileViewProtocol: AnyObject {
    func updateProfile(with name: String, email: String, imageUrl: String?)
    func navigateToLoginScreen()
    func showSignOutError(_ error: Error)
    func imageUploadCompleted()
}

final class ProfileVC: UIViewController {
    
    var changePhotoPresenter: ChangePhotoPresenter?
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
    
    /// buttons on the underside
    private let typeAccountView = UIView.makeGreyButton(textLabel: "Type of account",
                                                        textColor: .customDarkGray,
                                                        nameMarker: "chevron.forward",
                                                        colorMarker: .customDarkGray)
    
    private let termsView = UIView.makeGreyButton(textLabel: "Terms & Conditions",
                                                  textColor: .customDarkGray,
                                                  nameMarker: "chevron.forward",
                                                  colorMarker: .customDarkGray)
    
    private let signoutView = UIView.makeGreyButton(textLabel: "Log out",
                                                    textColor: .customDarkGray,
                                                    nameMarker: "arrow.forward.to.line.square",
                                                    colorMarker: .customDarkGray)
    
    // MARK: init
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
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
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self?.profileImage.image = UIImage(named: "defaultProfilePhoto") // Загрузка стандартного изображения в случае ошибки
                }
                return
            }
            DispatchQueue.main.async {
                self?.profileImage.image = image
            }
        }.resume()
    }
    
    // MARK: Selector Methods
    @objc private func settingsProfileButtonTapped() {
        let vc = SettingsVC()
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @objc private func changePhotoProfileButtonTapped() {
//        presenter.showChangePhotoVC()
        let profileBuilder = ProfileBuilder()
        let changePhotoVC = profileBuilder.createChangePhotoModule(delegate: self)
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
    
    deinit {
        print("ProfileVC deinited")
    }
}

// MARK: - Setup Constraints
private extension ProfileVC {
    
    func setupConstraints() {
        
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

// MARK: - Extension ProfileViewProtocol
extension ProfileVC: ProfileViewProtocol {
    
    func imageUploadFailed(_ error: any Error) {
        print(error.localizedDescription)
    }
    
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

// MARK: - Extension ChangePhotoPresenterDelegate
extension ProfileVC: ChangePhotoPresenterDelegate {
    func imageDidUpdate(url: String) {
        if let imageUrl = URL(string: url) {
            loadImage(from: imageUrl)
        }
    }
}

extension ProfileVC: SettingsVCDelegate {
    func didUpdateName(_ name: String) {
        profileName.text = name
    }
    
    func didUpdateEmail(_ email: String) {
        profileEmail.text = email
    }
}
