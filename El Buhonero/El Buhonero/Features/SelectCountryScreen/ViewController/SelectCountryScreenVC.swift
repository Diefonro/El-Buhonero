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
        self.fetchStores()
    }
    
    func setCoordinator(coordinator: Coordinator?) {
        self.coordinator = coordinator
    }
    
    func setViewModel(viewModel: SelectCountryViewModel) {
        self.viewModel = viewModel
    }

    func fetchStores() {
        Task {
            await viewModel?.getStoreAProducts()
            await viewModel?.getStoreBProducts()
        }
    }
}
