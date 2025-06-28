//
//  LoginViewModel.swift
//  El Buhonero
//
//  Created by Andrés Fonseca on 27/06/25.
//

import Foundation

class LoginViewModel {
    
    // MARK: - Callbacks
    var onLoginSuccess: (() -> Void)?
    var onLoginError: ((String) -> Void)?
    
    // MARK: - Authentication Logic
    func login(username: String, password: String) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) { [weak self] in
            if self?.validateCredentials(username: username, password: password) == true {
                DataManager.shared.setLoginState(loggedIn: true, username: username, password: password)
                self?.onLoginSuccess?()
            } else {
                self?.onLoginError?("Invalid username or password. Please try again.")
            }
        }
    }
    
    // MARK: - Private Methods
    private func validateCredentials(username: String, password: String) -> Bool {
        return username == "diefonroRocks" && password == "password123"
    }
} 
