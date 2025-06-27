//
//  PaymentScreenCoordinator.swift
//  El Buhonero
//
//  Created by Andrés Fonseca on 27/06/25.
//

import UIKit

class PaymentScreenCoordinator: Coordinating {
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
    
    func showPaymentSuccess() {
        let alert = UIAlertController(
            title: "Payment Successful!",
            message: "Your order has been processed successfully. You will be redirected to the home screen.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.coordinator?.popToRootController(animated: true)
        })
        
        if let topViewController = coordinator?.navigationController?.topViewController {
            topViewController.present(alert, animated: true)
        }
    }
    
    func showPaymentError(_ error: PaymentError) {
        let alert = UIAlertController(
            title: "Payment Failed",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Try Again", style: .default))
        
        if let topViewController = coordinator?.navigationController?.topViewController {
            topViewController.present(alert, animated: true)
        }
    }
} 