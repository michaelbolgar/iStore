//
//  SettingsVC.swift
//  iStore
//
//  Created by Nikita Shirobokov on 26.04.24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

// MARK: - Protocols

protocol SettingsVCDelegate: AnyObject {
    func didUpdateName(_ name: String)
    func didUpdateEmail(_ email: String)
}

// MARK: - SettingsVC

class SettingsVC: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: SettingsVCDelegate?
    private var db = Firestore.firestore()
    
    private lazy var nameLabel = UILabel.makeLabel(text: "Name",
                                                   font: UIFont.InterRegular(ofSize: 14),
                                                   textColor: .customLightGray,
                                                   numberOfLines: 0,
                                                   alignment: .left)
    
    private lazy var nameTextField = UITextField.makeTextField(placeholder: "Enter your new name",
                                                               backgroundColor: .violet,
                                                               textColor: .customLightGray,
                                                               font: UIFont.InterRegular(ofSize: 16),
                                                               height: 52)
    
    private lazy var emailLabel = UILabel.makeLabel(text: "Email",
                                                    font: UIFont.InterRegular(ofSize: 14),
                                                    textColor: .customLightGray,
                                                    numberOfLines: 0,
                                                    alignment: .left)
    
    private lazy var emailTextField = UITextField.makeTextField(placeholder: "Enter your new email",
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
    
    private lazy var updateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Update", for: .normal)
        button.backgroundColor = .lightGreen
        button.layer.cornerRadius = 12
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(updateButtonTapped), for: .touchUpInside)
        button.titleLabel?.font = UIFont.InterRegular(ofSize: 16)
        return button
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
        updatePasswordVisibilityButton()
        view.hideKeyboard()
    }
    
    // MARK: - Setup
    
    private func setupView() {
        view.backgroundColor = .white
        //        loginTextField.delegate = self
        //        passwordTextField.delegate = self
        
        let subviews = [nameLabel,
                        nameTextField,
                        emailLabel,
                        emailTextField,
                        passwordLabel,
                        passwordTextField,
                        updateButton]
        
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
    
    // MARK: Selector Methods
    
    @objc private func togglePasswordVisibility() {
        passwordTextField.isSecureTextEntry.toggle()
        updatePasswordVisibilityButton()
    }
    
    @objc private func updateButtonTapped() {
        let alertController = UIAlertController(title: "Confirm Password", message: "Please enter your password to update your profile", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.isSecureTextEntry = true
            textField.placeholder = "Password"
        }
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { [weak alertController, weak self] _ in
            guard let alertController = alertController, let self = self else { return }
            let password = alertController.textFields?.first?.text ?? ""
            
            if let passwordText = passwordTextField.text, !passwordText.isEmpty {
                self.confirmPasswordAndUpdateData(password: password)
            } else {
                self.checkConfirmPassword(password: password)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
    }
    
    // MARK: Private Methods
    
    private func updatePasswordVisibilityButton() {
        let imageName = passwordTextField.isSecureTextEntry ? "eye.fill" : "eye.slash.fill"
        showHideButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    private func confirmPasswordAndUpdateData(password: String) {
        guard let user = Auth.auth().currentUser, let email = user.email else {
            showAlertWith(title: "Error", message: "Could not fetch user data.")
            return
        }
        
        // Reauthenticate the user
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        user.reauthenticate(with: credential) { [weak self] _, error in
            if let error = error {
                self?.showAlertWith(title: "Reauthentication Failed", message: error.localizedDescription)
            } else {
                if let newPassword = self?.passwordTextField.text, !newPassword.isEmpty {
                    user.updatePassword(to: newPassword) { error in
                        if let error = error {
                            self?.showAlertWith(title: "Password Update Failed", message: error.localizedDescription)
                        } else {
                            self?.dismiss(animated: true)
                        }
                    }
                } else {
                }
            }
        }
    }
    
    private func checkConfirmPassword(password: String) {
        guard let user = Auth.auth().currentUser, let email = user.email else { return }
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        user.reauthenticate(with: credential) { [weak self] result, error in
            guard let self = self, error == nil else {
                self?.showAlertWith(title: "Authentication Failed", message: "Failed to authenticate with provided credentials.")
                return
            }
            self.updateUserProfile()
        }
    }
    
    private func updateUserProfile() {
        
        guard let user = Auth.auth().currentUser else { return }
        let userID = user.uid
        let newName = nameTextField.text
        let newEmail = emailTextField.text
        
        // Firestore data update
        var updateData: [String: Any] = [:]
        if let newName = newName, !newName.isEmpty {
            updateData["login"] = newName
        }
        if let newEmail = newEmail, !newEmail.isEmpty {
            updateData["email"] = newEmail
        }
        
        // Perform updates
        db.collection("users").document(userID).updateData(updateData) { error in
            if let error = error {
                self.showAlertWith(title: "Database Update Failed", message: error.localizedDescription)
            } else {
                // Authentication updates
                self.performAuthUpdates(newName: newName, newEmail: newEmail)
            }
        }
    }
    
    private func performAuthUpdates(newName: String?, newEmail: String?) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        if let newName = newName, !newName.isEmpty {
            changeRequest?.displayName = newName
            self.delegate?.didUpdateName(newName)
            self.dismiss(animated: true)
        }
        changeRequest?.commitChanges { error in
            if let error = error {
                self.showAlertWith(title: "Update Failed", message: "Failed to update name: \(error.localizedDescription)")
            }
        }
        
        if let newEmail = newEmail, !newEmail.isEmpty {
            Auth.auth().currentUser?.updateEmail(to: newEmail) { error in
                if let error = error {
                    self.showAlertWith(title: "Update Failed", message: "Failed to update email: \(error.localizedDescription)")
                } else {
                    self.delegate?.didUpdateEmail(newEmail)
                }
            }
        }
    }
    
    private func showAlertWith(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func setupLayout() {
        let standardSpacing: CGFloat = 16
        let closeSpacing: CGFloat = 5
        //        let largeBottomSpacing: CGFloat = 95
        let elementHeight: CGFloat = 57
        let topOffset: CGFloat = 64
        //        let smallVerticalSpacing: CGFloat = 2
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topOffset),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: standardSpacing),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -standardSpacing),
            
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: closeSpacing),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: standardSpacing),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -standardSpacing),
            
            emailLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: standardSpacing),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: standardSpacing),
            emailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -standardSpacing),
            
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: closeSpacing),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: standardSpacing),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -standardSpacing),
            
            passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: standardSpacing),
            passwordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: standardSpacing),
            passwordLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -standardSpacing),
            
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: closeSpacing),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: standardSpacing),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -standardSpacing),
            
            updateButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: standardSpacing + 10),
            updateButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: standardSpacing),
            updateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -standardSpacing),
            updateButton.heightAnchor.constraint(equalToConstant: elementHeight)
        ])
    }
}

