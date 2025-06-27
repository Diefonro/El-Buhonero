//
//  SelectCountryScreenVC.swift
//  El Buhonero
//
//  Created by Andrés Fonseca on 27/06/25.
//

import UIKit

class SelectCountryScreenVC: UIViewController, StoryboardInfo {
    
    var coordinator: SelectCountryScreenCoordinator?
    
    static var storyboard = "SelectCountryScreen"
    static var identifier = "SelectCountryScreenVC"
    
    var viewModel: SelectCountryViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setCoordinator(coordinator: SelectCountryScreenCoordinator?) {
        self.coordinator = coordinator
    }
    
    func setViewModel(viewModel: SelectCountryViewModel) {
        self.viewModel = viewModel
    }
    
    func goToLogin() {
        self.coordinator?.pushToLogin()
    }
    
    @IBAction func countryAButtonAction(_ sender: Any) {
        print("Isla de Man Selected")
        DataManager.shared.setSelectedCountry(.countryA)
        Task {
            await viewModel?.getStoreAProducts()
        }
        goToLogin()
    }
    
    @IBAction func countryBButtonAction(_ sender: Any) {
        print("Kiribati Selected")
        DataManager.shared.setSelectedCountry(.countryB)
        Task {
            await viewModel?.getStoreBProducts()
        }
        goToLogin()
    }
    
}
