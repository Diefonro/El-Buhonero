//
//  HomeScreenCoordinator.swift
//  El Buhonero
//
//  Created by Andrés Fonseca on 27/06/25.
//

import UIKit

class HomeScreenCoordinator: Coordinating {
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
    
    func presentSelectCountryScreen(onCountryChanged: @escaping () -> Void) {
        let storyboard = UIStoryboard(name: SelectCountryScreenVC.storyboard, bundle: nil)
        guard let selectCountryVC = storyboard.instantiateViewController(withIdentifier: SelectCountryScreenVC.identifier) as? SelectCountryScreenVC else { return }
        let selectCountryCoordinator = SelectCountryScreenCoordinator(coordinator: self.coordinator)
        selectCountryVC.setCoordinator(coordinator: selectCountryCoordinator)
        selectCountryVC.setViewModel(viewModel: SelectCountryViewModel())
        selectCountryVC.onCountryChanged = onCountryChanged
        self.coordinator?.push(viewController: selectCountryVC, animated: true)
    }
}
