//
//  ProductDetailScreenCoordinator.swift
//  El Buhonero
//
//  Created by Andrés Fonseca on 27/06/25.
//

import UIKit

class ProductDetailScreenCoordinator: Coordinating {
    var coordinator: Coordinator?
    
    init(coordinator: Coordinator?) {
        self.coordinator = coordinator
    }
    
    func start(with product: HomeProduct) {

    }
    
    func start(with productId: Int, country: String) {

    }
    
    func presentPaymentScreen(product: HomeProduct) {
        if let paymentScreen = UIStoryboard(name: PaymentScreenVC.storyboard, bundle: nil)
            .instantiateViewController(withIdentifier: PaymentScreenVC.identifier) as? PaymentScreenVC {
            paymentScreen.setCoordinator(coordinator: PaymentScreenCoordinator(coordinator: self.coordinator))
            paymentScreen.setViewModel(viewModel: PaymentScreenViewModel(product: product))
            self.coordinator?.push(viewController: paymentScreen, animated: true)
        }
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
} 
