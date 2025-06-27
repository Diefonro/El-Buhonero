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
            self.pushToCountriesScreen()
        }
    }
    
    func pushToCountriesScreen() {
        UIView.animate(withDuration: 3.0) {
            self.imageView.alpha = 1
        } completion: { _ in
            if let countriesScreen = UIStoryboard(name: SelectCountryScreenVC.storyboard, bundle: nil)
                .instantiateViewController(withIdentifier: SelectCountryScreenVC.identifier) as? SelectCountryScreenVC {
                countriesScreen.setCoordinator(coordinator: self.coordinator)
                self.coordinator?.push(viewController: countriesScreen, animated: true)
            }
        }
    }
}
