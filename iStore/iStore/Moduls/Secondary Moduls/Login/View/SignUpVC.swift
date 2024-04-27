import UIKit
import Firebase

class SignUpVC: UIViewController {
    
    var selectedAccountType: String?
    
    // MARK: UI Elements
    
    private lazy var completeAccountLabel = UILabel.makeLabel(text: "Complete your account",
                                                              font: .InterBold(ofSize: 24),
                                                              textColor: .customDarkGray,
                                                              numberOfLines: 0,
                                                              alignment: .center)
    
    private lazy var loginLabel = UILabel.makeLabel(text: "Login",
                                                    font: UIFont.InterRegular(ofSize: 14),
                                                    textColor: .customLightGray,
                                                    numberOfLines: 0,
                                                    alignment: .left)
    
    private lazy var loginTextField = UITextField.makeTextField(placeholder: "Enter your login",
                                                                backgroundColor: .violet,
                                                                textColor: .customLightGray,
                                                                font: UIFont.InterRegular(ofSize: 16),
                                                                height: 52)
    
    private lazy var emailLabel = UILabel.makeLabel(text: "E-mail",
                                                    font: UIFont.InterRegular(ofSize: 14),
                                                    textColor: .customLightGray,
                                                    numberOfLines: 0,
                                                    alignment: .left)
    
    private lazy var emailTextField = UITextField.makeTextField(placeholder: "Enter your e-mail",
                                                                backgroundColor: .violet,
                                                                textColor: .customLightGray,
                                                                font: UIFont.InterRegular(ofSize: 16),
                                                                height: 52)
    
    private lazy var passwordLabel = UILabel.makeLabel(text: "Password",
                                                       font: UIFont.InterRegular(ofSize: 14),
                                                       textColor: .customLightGray,
                                                       numberOfLines: 0,
                                                       alignment: .left)
    
    private lazy var passwordTextField = UITextField.makeTextField(placeholder: "Enter your password",
                                                                   backgroundColor: .violet,
                                                                   textColor: .customLightGray,
                                                                   font: UIFont.InterRegular(ofSize: 16),
                                                                   height: 52)
    
    private lazy var confirmPasswordLabel = UILabel.makeLabel(text: "Confirm your password",
                                                              font: UIFont.InterRegular(ofSize: 14),
                                                              textColor: .customLightGray,
                                                              numberOfLines: 0,
                                                              alignment: .left)
    
    private lazy var confirmPasswordTextField = UITextField.makeTextField(placeholder: "Confirm your password",
                                                                          backgroundColor: .violet,
                                                                          textColor: .customLightGray,
                                                                          font: UIFont.InterRegular(ofSize: 16),
                                                                          height: 52)
    
    private lazy var alreadyHaveAccountLabel = UILabel.makeLabel(text: "Already have an account?",
                                                                 font: UIFont.InterBold(ofSize: 16),
                                                                 textColor: .customLightGray,
                                                                 numberOfLines: 0,
                                                                 alignment: .center)
    
    private lazy var accountTypeButton = UIView.makeView(textLabel: "Type of account",
                                                         textColor: .customLightGray,
                                                         nameMarker: "chevron.right",
                                                         colorMarker: .customLightGray)
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var accountLoginStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 5
        stack.alignment = .center
        stack.distribution = .fill
        return stack
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = .lightGreen
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .InterBold(ofSize: 16)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.tintColor = .lightGreen
        button.titleLabel?.font = .InterBold(ofSize: 16)
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
        setupTogglePassword()
        view.hideKeyboard()
    }
    
    // MARK: Private Methods
    
    private func setupView() {
        view.backgroundColor = .white
        
        loginTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        //добавляем рекогнайзер на кнопки(вью)
        accountTypeButton.isUserInteractionEnabled = true
        let typeAccountTapGesture = UITapGestureRecognizer(target: self, action: #selector(typeAccountViewTapped))
        accountTypeButton.addGestureRecognizer(typeAccountTapGesture)
        
        setNavigationBar(title: "Sign Up")
        
        navigationController?.isNavigationBarHidden = false
        
        let views = [scrollView,
                     completeAccountLabel,
                     loginLabel,
                     loginTextField,
                     emailLabel,
                     emailTextField,
                     passwordLabel,
                     passwordTextField,
                     confirmPasswordLabel,
                     confirmPasswordTextField,
                     accountTypeButton,
                     signUpButton,
                     accountLoginStack]
        
        views.forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        scrollView.addSubview(contentView)
        accountLoginStack.addArrangedSubview(alreadyHaveAccountLabel)
        accountLoginStack.addArrangedSubview(loginButton)
        
        accountLoginStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupTogglePassword() {
        let passwordToggle = createVisibilityToggle(action: #selector(togglePasswordVisibility))
        passwordTextField.rightView = passwordToggle.container
        passwordTextField.rightViewMode = .always
        passwordTextField.isSecureTextEntry = true
        passwordTextField.tintColor = .customLightGray
        
        let confirmPasswordToggle = createVisibilityToggle(action: #selector(toggleConfirmPasswordVisibility))
        confirmPasswordTextField.rightView = confirmPasswordToggle.container
        confirmPasswordTextField.rightViewMode = .always
        confirmPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextField.tintColor = .customLightGray
    }
    
    private func saveUserData() {
        guard let userID = Auth.auth().currentUser?.uid,
              let login = loginTextField.text,
              let email = emailTextField.text,
              let accountType = selectedAccountType else {
              AlertService.shared.showAlert(title: "Error", message: "Not all fields are filled")
            return
        }
        let db = Firestore.firestore()
        db.collection("users").document(userID).setData([
            "login": login,
            "email": emailTextField.text ?? "",
            "typeOfAccount": accountType
        ]) { error in
            if let error = error {
                AlertService.shared.showAlert(title: "Error", message: error.localizedDescription)
            } else {
                print("User data saved successfully")
                self.navigationController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // MARK: Selector Methods
    
    @objc private func typeAccountViewTapped() {
        let changeProfileVC = ChangeProfileViewController()
        changeProfileVC.delegate = self
        changeProfileVC.modalPresentationStyle = .automatic
        present(changeProfileVC, animated: true, completion: nil)
    }
    
    @objc private func loginButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func signUpButtonTapped() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                AlertService.shared.showAlert(title: "Error", message: error.localizedDescription)
            } else {
                self.saveUserData()
            }
        }
    }
    
    @objc private func togglePasswordVisibility() {
        passwordTextField.isSecureTextEntry.toggle()
        updateButtonImage(button: passwordTextField.rightView?.subviews.first as! UIButton,
                          isSecure: passwordTextField.isSecureTextEntry)
    }
    
    @objc private func toggleConfirmPasswordVisibility() {
        confirmPasswordTextField.isSecureTextEntry.toggle()
        updateButtonImage(button: confirmPasswordTextField.rightView?.subviews.first as! UIButton,
                          isSecure: confirmPasswordTextField.isSecureTextEntry)
    }
}

// MARK: Extensions

extension SignUpVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case loginTextField:
            if textField.text?.isEmpty ?? true {
                textField.placeholder = "Enter your login"
            }
        case emailTextField:
            if textField.text?.isEmpty ?? true {
                textField.placeholder = "Enter your E-mail"
            }
        case passwordTextField:
            if textField.text?.isEmpty ?? true {
                textField.placeholder = "Enter your password"
            }
        case confirmPasswordTextField:
            if textField.text?.isEmpty ?? true {
                textField.placeholder = "Confirm your password"
            }
        default:
            break
        }
    }
}

// Create containers of buttons
extension SignUpVC {
    private func createVisibilityToggle(action: Selector) -> (container: UIView, button: UIButton) {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        button.tintColor = .customLightGray
        button.addTarget(self, action: action, for: .touchUpInside)
        button.frame = CGRect(x: -10, y: 0, width: 30, height: 30)
        
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 30))
        container.addSubview(button)
        
        return (container, button)
    }
    
    private func updateButtonImage(button: UIButton, isSecure: Bool) {
        let imageName = isSecure ? "eye.fill" : "eye.slash.fill"
        button.setImage(UIImage(systemName: imageName), for: .normal)
    }
}

// Временный экстеншн, далее удалится, как Семен его добавит :)
extension UIView {
    static func makeView(textLabel: String, textColor: UIColor, nameMarker: String, colorMarker: UIColor) -> UIView {
        
        let view = UIView()
        
        view.layer.cornerRadius = 12
        view.backgroundColor = UIColor.lightViolet
        view.tintColor = UIColor.darkGray
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // Создание и настройка надписи
        let label = UILabel.makeLabel(text: textLabel,
                                      font: UIFont.systemFont(ofSize: 16, weight: .semibold),
                                      textColor: textColor,
                                      numberOfLines: 1,
                                      alignment: .left)
        
        // Создание и настройка метки
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: nameMarker)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = colorMarker
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            
            view.heightAnchor.constraint(equalToConstant: 56)
        ])
        return view
    }
}

// MARK: Layout

extension SignUpVC {
    private func setupLayout() {
        let standardSpacing: CGFloat = 20
        let closeSpacing: CGFloat = 5
        let buttonHeight: CGFloat = 57
        let sidePadding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            completeAccountLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: standardSpacing),
            completeAccountLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            loginLabel.topAnchor.constraint(equalTo: completeAccountLabel.bottomAnchor, constant: standardSpacing),
            loginLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: sidePadding),
            loginLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -sidePadding),
            
            loginTextField.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: closeSpacing),
            loginTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: sidePadding),
            loginTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -sidePadding),
            
            emailLabel.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: standardSpacing),
            emailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: sidePadding),
            emailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -sidePadding),
            
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: closeSpacing),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: sidePadding),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -sidePadding),
            
            passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: standardSpacing),
            passwordLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: sidePadding),
            passwordLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -sidePadding),
            
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: closeSpacing),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: sidePadding),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -sidePadding),
            
            confirmPasswordLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: standardSpacing),
            confirmPasswordLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: sidePadding),
            confirmPasswordLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -sidePadding),
            
            confirmPasswordTextField.topAnchor.constraint(equalTo: confirmPasswordLabel.bottomAnchor, constant: closeSpacing),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: sidePadding),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -sidePadding),
            
            accountTypeButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: standardSpacing),
            accountTypeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: sidePadding),
            accountTypeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -sidePadding),
            
            signUpButton.topAnchor.constraint(equalTo: accountTypeButton.bottomAnchor, constant: standardSpacing),
            signUpButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: sidePadding),
            signUpButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -sidePadding),
            signUpButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            accountLoginStack.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: standardSpacing),
            accountLoginStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            accountLoginStack.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: sidePadding),
            accountLoginStack.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -sidePadding),
            accountLoginStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -standardSpacing)
        ])
    }
}

extension SignUpVC: ChangeProfileViewControllerDelegate {
    func didSelectAccountType(_ type: String) {
        selectedAccountType = type
//        accountTypeButton.setTitle(type, for: .normal)
        print("Type selected: \(type)")
    }
}
