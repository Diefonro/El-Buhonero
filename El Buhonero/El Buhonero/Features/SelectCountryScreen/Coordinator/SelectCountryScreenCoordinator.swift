//
//  SelectCountryScreenCoordinator.swift
//  El Buhonero
//
//  Created by Andrés Fonseca on 27/06/25.
//

import UIKit

class SelectCountryScreenCoordinator: Coordinating {
    var coordinator: Coordinator?
    
    init(coordinator: Coordinator?) {
        self.coordinator = coordinator
    }
    
    func showNavigationBar(animated: Bool = false) {
        self.coordinator?.showNavigationBar(animated: animated)
    }
    
    func hideNavigationBar(animated: Bool = false) {
        self.coordinator?.hideNavigationBar(animated: animated)
    }
    
    func popToRootController(animated: Bool) {
        self.coordinator?.popToRootController(animated: animated)
    }
    
    func pop(animated: Bool) {
        self.coordinator?.pop(animated: animated)
    }
    
    func enableDragPopGesture() {
        self.coordinator?.enableDragPopGesture()
    }
    
    func disableDragPopGesture() {
        self.coordinator?.disableDragPopGesture()
    }
    
    func pushToLogin() {
        if let loginScreen = UIStoryboard(name: LoginScreenVC.storyboard, bundle: nil)
            .instantiateViewController(withIdentifier: LoginScreenVC.identifier) as? LoginScreenVC {
            loginScreen.setCoordinator(coordinator: LoginScreenCoordinator(coordinator: self.coordinator))
            loginScreen.setViewModel(viewModel: LoginViewModel())
            self.coordinator?.push(viewController: loginScreen, animated: true)
        }
    }
    
    func pushToHomeScreen() {
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
}
