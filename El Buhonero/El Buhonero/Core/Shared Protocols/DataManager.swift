//
//  DataManager.swift
//  El Buhonero
//
//  Created by Andrés Fonseca on 27/06/25.
//

import Foundation

enum SelectedCountry {
    case countryA // Isla de Man - Fake Store API
    case countryB // Kiribati - Platzi Fake Store API
    case none
}

class DataManager {
    static let shared = DataManager()
    
    var selectedCountry: SelectedCountry = .none
    var storeAData: StoreAModel = []
    var storeBData: StoreBModel = []
    
    // MARK: - Login State Management
    private var isLoggedIn: Bool = false
    private var savedUsername: String = ""
    private var savedPassword: String = ""
    
    func setLoginState(loggedIn: Bool, username: String = "", password: String = "") {
        self.isLoggedIn = loggedIn
        if loggedIn {
            self.savedUsername = username
            self.savedPassword = password
        }
    }
    
    func isUserLoggedIn() -> Bool {
        return isLoggedIn
    }
    
    func getSavedCredentials() -> (username: String, password: String) {
        return (savedUsername, savedPassword)
    }
    
    func clearLoginState() {
        isLoggedIn = false
        savedUsername = ""
        savedPassword = ""
    }
    
    // MARK: - Helper Methods
    func setSelectedCountry(_ country: SelectedCountry) {
        self.selectedCountry = country
    }
    
    func getSelectedCountryName() -> String {
        switch selectedCountry {
        case .countryA:
            return "🇮🇲 Isla de Man"
        case .countryB:
            return "🇰🇮 Kiribati"
        case .none:
            return "No country selected"
        }
    }
    
    func getSelectedCountryDescription() -> String {
        switch selectedCountry {
        case .countryA:
            return "Products from Fake Store API"
        case .countryB:
            return "Products from Platzi Fake Store API"
        case .none:
            return "Please select a country first"
        }
    }
}
