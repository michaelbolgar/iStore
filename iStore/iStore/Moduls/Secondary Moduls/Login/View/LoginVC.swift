import UIKit

class LoginVC: UIViewController {
    
    // MARK: UI Elements
    
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
    
    private lazy var signUpLabel = UILabel.makeLabel(text: "Do you still not have an account?", 
                                                     font: UIFont.InterBold(ofSize: 16), 
                                                     textColor: .customLightGray, 
                                                     numberOfLines: 0, 
                                                     alignment: .center)
    
    private lazy var passwordTextFieldContainer: UIView = {
        let container = UIView()
        container.frame = CGRect(x: 0, y: 0, width: 35, height: 30)
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    private lazy var showHideButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        button.frame = CGRect(x: -10, y: 0, width: 30, height: 30)
        button.tintColor = .customLightGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        return button
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .lightGreen
        button.layer.cornerRadius = 12
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        button.titleLabel?.font = UIFont.InterRegular(ofSize: 16)
        return button
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.tintColor = .lightGreen
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        button.titleLabel?.font = UIFont.InterBold(ofSize: 16)
        return button
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
        updatePasswordVisibilityButton()
        tapGestureKeyboard()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        loginTextField.delegate = self
        passwordTextField.delegate = self
        
        let subviews = [loginLabel, 
                        loginTextField, 
                        passwordLabel, 
                        passwordTextField, 
                        loginButton, 
                        signUpLabel, 
                        signUpButton]
        
        subviews.forEach { view.addSubview($0) }
        
        subviews.forEach { subview in
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
        
        showHideButton.translatesAutoresizingMaskIntoConstraints = true
        
        passwordTextFieldContainer.addSubview(showHideButton)
        passwordTextField.rightView = passwordTextFieldContainer
        passwordTextField.rightViewMode = .always
        passwordTextField.isSecureTextEntry = true
        passwordTextField.tintColor = .customLightGray
    }
    
    // MARK: Private Methods
    
    private func updatePasswordVisibilityButton() {
        let imageName = passwordTextField.isSecureTextEntry ? "eye.fill" : "eye.slash.fill"
        showHideButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    // MARK: Selector Methods
    
    @objc private func togglePasswordVisibility() {
        passwordTextField.isSecureTextEntry.toggle()
        updatePasswordVisibilityButton()
    }
    
    @objc private func loginButtonTapped() {
        
    }
    
    @objc private func signUpButtonTapped() {
        let signUpVC = SignUpVC()
        navigationController?.pushViewController(signUpVC, animated: true)
    }
}

// MARK: Extensions

extension LoginVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.isEmpty ?? true {
            if textField == loginTextField {
                textField.placeholder = "Enter your login"
            } else if textField == passwordTextField {
                textField.placeholder = "Enter your password"
            }
        }
    }
}

// End editing and dismiss keyboard
extension LoginVC {
    
    private func tapGestureKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

//Layouts
extension LoginVC {
    
    private func setupLayout() {
        let standardSpacing: CGFloat = 16
        let closeSpacing: CGFloat = 5
        let largeBottomSpacing: CGFloat = 95
        let elementHeight: CGFloat = 57
        let topOffset: CGFloat = 64
        let smallVerticalSpacing: CGFloat = 2
        
        NSLayoutConstraint.activate([
            loginLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topOffset),
            loginLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: standardSpacing),
            loginLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -standardSpacing),
            
            loginTextField.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: closeSpacing),
            loginTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: standardSpacing),
            loginTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -standardSpacing),
            
            passwordLabel.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: standardSpacing),
            passwordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: standardSpacing),
            passwordLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -standardSpacing),
            
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: closeSpacing),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: standardSpacing),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -standardSpacing),
            
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: standardSpacing),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: standardSpacing),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -standardSpacing),
            loginButton.heightAnchor.constraint(equalToConstant: elementHeight),
            
            signUpLabel.bottomAnchor.constraint(equalTo: signUpButton.topAnchor, constant: -smallVerticalSpacing),
            signUpLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: standardSpacing),
            signUpLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -standardSpacing),
            
            signUpButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -largeBottomSpacing),
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: standardSpacing),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -standardSpacing)
        ])
    }
}
