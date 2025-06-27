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
                if DataManager.shared.isUserLoggedIn() {
                    self?.coordinator?.pop(animated: true)
                } else {
                    self?.goToLogin()
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
                if DataManager.shared.isUserLoggedIn() {
                    self?.coordinator?.pop(animated: true)
                } else {
                    self?.goToLogin()
                }
            }
        }
    }
    
}
