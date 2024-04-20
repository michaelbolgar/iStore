//
//  LoginPresenter.swift
//  iStore
//
//  Created by Nikita Shirobokov on 19.04.24.
//

import Foundation
import Firebase

protocol LoginPresenterProtocol: AnyObject {
    func loginButtonTapped(username: String?, password: String?)
    func logOutButtonTapped()
}

protocol RegistrationPresenterProtocol: AnyObject {
    func registerButtonTapped(username: String?, password: String?)
}

class LoginPresenter: LoginPresenterProtocol {
    
    weak var view: LoginViewProtocol?
    
    init(view: LoginViewProtocol) {
        self.view = view
    }
    
    func loginButtonTapped(username: String?, password: String?) {
        
        if let username = username, let password = password {
            
            Auth.auth().signIn(withEmail: username, password: password) { authResult, error in
                if let error = error {
                    self.view?.showSuccessPopup(message: error.localizedDescription)
                } else {
                    print("Success")
                }
            }
        }
    }
    
    func logOutButtonTapped() {
        do {
            try Auth.auth().signOut()
            self.view?.showSuccessPopup(message: "Success Log Out")
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            self.view?.showSuccessPopup(message: "Error signing out: %@")
        }
    }
}

class RegistrationPresenter: RegistrationPresenterProtocol {
    
    weak var view: RegistrationViewProtocol?
    
    func registerButtonTapped(username: String?, password: String?) {
        
        if let username = username, let password = password {
            
            Auth.auth().createUser(withEmail: username, password: password) { authResult, error in
                if let error = error {
                    self.view?.showSuccessPopup(message: error.localizedDescription)
                } else {
                    print("Registration Success")
                }
            }
        }
    }
}
