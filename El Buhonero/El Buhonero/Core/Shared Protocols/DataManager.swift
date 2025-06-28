//
//  DataManager.swift
//  El Buhonero
//
//  Created by Andrés Fonseca on 27/06/25.
//

import Foundation

enum SelectedCountry: String, CaseIterable {
    case countryA = "countryA" // Isla de Man - Fake Store API
    case countryB = "countryB" // Kiribati - Platzi Fake Store API
    case none = "none"
}

class DataManager {
    static let shared = DataManager()
    
    // MARK: - UserDefaults Keys
    private let selectedCountryKey = "selectedCountry"
    private let isLoggedInKey = "isLoggedIn"
    private let savedUsernameKey = "savedUsername"
    private let savedPasswordKey = "savedPassword"
    
    var storeAData: StoreAModel = []
    var storeBData: StoreBModel = []
    
    // MARK: - Computed Properties with UserDefaults
    var selectedCountry: SelectedCountry {
        get {
            let rawValue = UserDefaults.standard.string(forKey: selectedCountryKey) ?? "none"
            return SelectedCountry(rawValue: rawValue) ?? .none
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: selectedCountryKey)
        }
    }
    
    // MARK: - Login State Management
    private var isLoggedIn: Bool {
        get {
            return UserDefaults.standard.bool(forKey: isLoggedInKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: isLoggedInKey)
        }
    }
    
    private var savedUsername: String {
        get {
            return UserDefaults.standard.string(forKey: savedUsernameKey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: savedUsernameKey)
        }
    }
    
    private var savedPassword: String {
        get {
            return UserDefaults.standard.string(forKey: savedPasswordKey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: savedPasswordKey)
        }
    }
    
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
