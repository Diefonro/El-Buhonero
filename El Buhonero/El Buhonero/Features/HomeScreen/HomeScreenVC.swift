//
//  HomeScreenVC.swift
//  El Buhonero
//
//  Created by Andrés Fonseca on 27/06/25.
//

import UIKit

class HomeScreenVC: UIViewController, StoryboardInfo {
    
    static var storyboard = "HomeScreen"
    static var identifier = "HomeScreenVC"
    
    // MARK: - IBOutlets
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var productsCountLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        displayCountryInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        displayCountryInfo()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        countryLabel.textAlignment = .center
        countryLabel.font = UIFont.boldSystemFont(ofSize: 24)
        
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0
        
        productsCountLabel.textAlignment = .center
        productsCountLabel.font = UIFont.systemFont(ofSize: 14)
    }
    
    // MARK: - Display Country Info
    private func displayCountryInfo() {
        let dataManager = DataManager.shared
        
        countryLabel.text = dataManager.getSelectedCountryName()
        descriptionLabel.text = dataManager.getSelectedCountryDescription()
        
        // Display products count based on selected country
        switch dataManager.selectedCountry {
        case .countryA:
            let count = dataManager.storeAData.count
            productsCountLabel.text = "\(count) products loaded from Fake Store API"
        case .countryB:
            let count = dataManager.storeBData.count
            productsCountLabel.text = "\(count) products loaded from Platzi Fake Store API"
        case .none:
            productsCountLabel.text = "No products loaded"
        }
    }
}
