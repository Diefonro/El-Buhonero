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
    
    var viewModel: SelectCountryViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setCoordinator(coordinator: Coordinator?) {
        self.coordinator = coordinator
    }
    
    func setViewModel(viewModel: SelectCountryViewModel) {
        self.viewModel = viewModel
    }
    
    @IBAction func countryAButtonAction(_ sender: Any) {
        print("Isla de Man Selected")
        Task {
            await viewModel?.getStoreAProducts()
        }
    }
    
    @IBAction func countryBButtonAction(_ sender: Any) {
        print("Kiribati Selected")
        Task {
            await viewModel?.getStoreBProducts()
        }
    }
    
}
