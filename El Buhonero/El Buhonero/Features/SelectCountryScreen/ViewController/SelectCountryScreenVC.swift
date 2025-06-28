//
//  SelectCountryScreenVC.swift
//  El Buhonero
//
//  Created by Andrés Fonseca on 27/06/25.
//

import UIKit

class SelectCountryScreenVC: UIViewController, StoryboardInfo {
    
    var coordinator: SelectCountryScreenCoordinator?
    
    static var storyboard = "SelectCountryScreen"
    static var identifier = "SelectCountryScreenVC"
    
    var viewModel: SelectCountryViewModel?
    var onCountryChanged: (() -> Void)?
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator()
    }
    
    private func setupActivityIndicator() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .white
    }
    
    func setCoordinator(coordinator: SelectCountryScreenCoordinator?) {
        self.coordinator = coordinator
    }
    
    func setViewModel(viewModel: SelectCountryViewModel) {
        self.viewModel = viewModel
    }
    
    func goToLogin() {
        self.coordinator?.pushToLogin()
    }
    
    @IBAction func countryAButtonAction(_ sender: Any) {
        print("Isla de Man Selected")
        activityIndicator.startAnimating()
        DataManager.shared.setSelectedCountry(.countryA)
        Task {
            await viewModel?.getStoreAProducts()
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicator.stopAnimating()
                self?.onCountryChanged?()
                
                // If onCountryChanged is set, we're coming from home screen
                // Just pop back to home screen without checking login
                if self?.onCountryChanged != nil {
                    self?.coordinator?.pop(animated: true)
                } else {
                    // Initial app flow - check login status
                    if DataManager.shared.isUserLoggedIn() {
                        self?.coordinator?.pushToHomeScreen()
                    } else {
                        self?.goToLogin()
                    }
                }
            }
        }
    }
    
    @IBAction func countryBButtonAction(_ sender: Any) {
        print("Kiribati Selected")
        activityIndicator.startAnimating()
        DataManager.shared.setSelectedCountry(.countryB)
        Task {
            await viewModel?.getStoreBProducts()
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicator.stopAnimating()
                self?.onCountryChanged?()
                
                // If onCountryChanged is set, we're coming from home screen
                // Just pop back to home screen without checking login
                if self?.onCountryChanged != nil {
                    self?.coordinator?.pop(animated: true)
                } else {
                    // Initial app flow - check login status
                    if DataManager.shared.isUserLoggedIn() {
                        self?.coordinator?.pushToHomeScreen()
                    } else {
                        self?.goToLogin()
                    }
                }
            }
        }
    }
    
}
