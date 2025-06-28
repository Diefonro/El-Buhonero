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
    
    func presentProductDetailScreen(product: HomeProduct) {
        if let detailScreen = UIStoryboard(name: ProductDetailScreenVC.storyboard, bundle: nil)
            .instantiateViewController(withIdentifier: ProductDetailScreenVC.identifier) as? ProductDetailScreenVC {
            detailScreen.setCoordinator(coordinator: ProductDetailScreenCoordinator(coordinator: self.coordinator))
            detailScreen.setViewModel(viewModel: ProductDetailViewModel(product: product))
            self.coordinator?.push(viewController: detailScreen, animated: true)
        }
    }

    
    func presentQRScanScreen() {
        if let qrScanVC = UIStoryboard(name: QRScanScreenVC.storyboard, bundle: nil)
            .instantiateViewController(withIdentifier: QRScanScreenVC.identifier) as? QRScanScreenVC {
            qrScanVC.setCoordinator(coordinator: QRScanScreenCoordinator(coordinator: self.coordinator))
            qrScanVC.setViewModel(viewModel: QRScanScreenViewModel())
            self.coordinator?.showNavigationBar(animated: true)
            self.coordinator?.push(viewController: qrScanVC, animated: true)
        }
    }
    
    func presentPurchaseHistoryScreen() {
        let purchaseHistoryVC = PurchaseHistoryHostingController()
        self.coordinator?.hideNavigationBar(animated: true)
        self.coordinator?.push(viewController: purchaseHistoryVC, animated: true)
    }
}
