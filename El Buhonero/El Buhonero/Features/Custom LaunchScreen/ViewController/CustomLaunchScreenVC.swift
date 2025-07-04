//
//  CustomLaunchScreenVC.swift
//  El Buhonero
//
//  Created by Andrés Fonseca on 26/06/25.
//

import UIKit

class CustomLaunchScreenVC: UIViewController, StoryboardInfo, Coordinating {
    
    var coordinator: Coordinator?
    
    static var storyboard = "CustomLaunchScreen"
    static var identifier = "CustomLaunchScreenVC"

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.coordinator?.hideNavigationBar(animated: true)
        self.coordinator?.disableDragPopGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 3.0) {
            self.imageView.alpha = 1
            self.imageView.showScaleEffectAnimated()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.checkSessionAndNavigate()
        }
    }
    
    private func checkSessionAndNavigate() {
        let dataManager = DataManager.shared
        
        // Check if user is logged in and has selected a country
        if dataManager.isUserLoggedIn() && dataManager.selectedCountry != .none {
            // User is logged in and has a country selected, go directly to home
            navigateToHomeScreen()
        } else {
            // User needs to select country and/or login
            pushToCountriesScreen()
        }
    }
    
    private func navigateToHomeScreen() {
        if let homeScreen = UIStoryboard(name: HomeScreenVC.storyboard, bundle: nil)
            .instantiateViewController(withIdentifier: HomeScreenVC.identifier) as? HomeScreenVC {
            homeScreen.setCoordinator(coordinator: HomeScreenCoordinator(coordinator: self.coordinator))
            homeScreen.setViewModel(viewModel: HomeScreenViewModel())
            
            // Replace the current view controller stack with home screen
            // This ensures no back button appears
            self.coordinator?.navigationController?.setViewControllers([homeScreen], animated: true)
            
            // Hide navigation bar for home screen
            self.coordinator?.hideNavigationBar(animated: true)
        }
    }
    
    func pushToCountriesScreen() {
        UIView.animate(withDuration: 3.0) {
            self.imageView.alpha = 1
        } completion: { _ in
            if let countriesScreen = UIStoryboard(name: SelectCountryScreenVC.storyboard, bundle: nil)
                .instantiateViewController(withIdentifier: SelectCountryScreenVC.identifier) as? SelectCountryScreenVC {
                countriesScreen.setCoordinator(coordinator: SelectCountryScreenCoordinator(coordinator: self.coordinator))
                countriesScreen.setViewModel(viewModel: SelectCountryViewModel())
                self.coordinator?.push(viewController: countriesScreen, animated: true)
            }
        }
    }
}
