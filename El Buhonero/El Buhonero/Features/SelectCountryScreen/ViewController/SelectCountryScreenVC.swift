//
//  SelectCountryScreenVC.swift
//  El Buhonero
//
//  Created by Andrés Fonseca on 27/06/25.
//

import UIKit

class SelectCountryScreenVC: UIViewController, StoryboardInfo, Coordinating {
   
    var coordinator: Coordinator?
    
    static var storyboard = "SelectCountryScreen"
    static var identifier = "SelectCountryScreenVC"

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func setCoordinator(coordinator: Coordinator?) {
        self.coordinator = coordinator
    }


}
