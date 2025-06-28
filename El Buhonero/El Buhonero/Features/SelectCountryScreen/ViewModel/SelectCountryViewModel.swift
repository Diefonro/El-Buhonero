//
//  SelectCountryViewModel.swift
//  El Buhonero
//
//  Created by Andrés Fonseca on 27/06/25.
//

import Foundation

class SelectCountryViewModel {
    
    let storesService = StoresServices()
    
    // MARK: StoreA Products
    func getStoreAProducts() async {
        let result = await storesService.getStoreAProducts()
        switch result {
        case .success(let data):
            print("StoreA Success")
            DataManager.shared.storeAData = data
        case .failure(let error):
            print("StoreA fetch error")
            AppError.handle(error: error)
        }
    }
    
    // MARK: StoreB Products
    func getStoreBProducts() async {
        let result = await storesService.getStoreBProducts()
        switch result {
        case .success(let data):
            print("Store B Success")
            DataManager.shared.storeBData = data
        case .failure(let error):
            print("StoreB fetch error")
            AppError.handle(error: error)
        }
    }
}
