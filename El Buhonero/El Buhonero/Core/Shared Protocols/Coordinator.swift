//
//  Coordinator.swift
//  El Buhonero
//
//  Created by Andrés Fonseca on 27/06/25.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController? { get set }
    func push(viewController: UIViewController, animated: Bool)
    func pop(animated: Bool)
    func showNavigationBar(animated: Bool)
    func hideNavigationBar(animated: Bool)
    func disableDragPopGesture()
    func popToRootController(animated: Bool)
}

extension Coordinator {
    func push(viewController: UIViewController, animated: Bool) {
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
    
    func pop(animated: Bool) {
        self.navigationController?.popViewController(animated: animated)
    }
    
    func showNavigationBar(animated: Bool = false) {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func hideNavigationBar(animated: Bool = false) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func enableDragPopGesture() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func disableDragPopGesture() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func popToRootController(animated: Bool) {
        if let navigationControllers = self.navigationController?.viewControllers,
           navigationControllers.count > 2 {
            self.navigationController?.popToViewController(navigationControllers[1], animated: animated)
        }
    }
}

protocol Coordinating {
    var coordinator: Coordinator? { get set }
}
