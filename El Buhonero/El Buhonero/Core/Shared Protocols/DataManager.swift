//
//  DataManager.swift
//  El Buhonero
//
//  Created by Andrés Fonseca on 27/06/25.
//

import Foundation

class DataManager {
    static let shared = DataManager()
    
    var storeAData: StoreAModel = []
    var storeBData: StoreBModel = []
}
