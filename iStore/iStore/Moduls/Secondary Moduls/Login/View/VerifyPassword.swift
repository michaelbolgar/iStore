//
//  VerifyPassword.swift
//  iStore
//
//  Created by Nikita Shirobokov on 27.04.24.
//

import Foundation

func verifyPassword(_ userInput: String) -> Bool {
    if let appPassword = Bundle.main.infoDictionary?["AppPassword"] as? String {
        return userInput == appPassword
    }
    return false
}
