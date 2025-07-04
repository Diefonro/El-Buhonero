//
//  QRScanScreenCoordinator.swift
//  El Buhonero
//
//  Created by Andrés Fonseca on 27/06/25.
//

import UIKit

class QRScanScreenCoordinator: Coordinating {
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
    
    func presentProductDetailFromQR(qrData: QRCodeData) {
        if let detailScreen = UIStoryboard(name: ProductDetailScreenVC.storyboard, bundle: nil)
            .instantiateViewController(withIdentifier: ProductDetailScreenVC.identifier) as? ProductDetailScreenVC {
            detailScreen.setCoordinator(coordinator: ProductDetailScreenCoordinator(coordinator: self.coordinator))
            let viewModel = ProductDetailViewModel(productId: qrData.productId, country: qrData.country)
                detailScreen.setViewModel(viewModel: viewModel)
            self.coordinator?.push(viewController: detailScreen, animated: true)
        }
    }
}
