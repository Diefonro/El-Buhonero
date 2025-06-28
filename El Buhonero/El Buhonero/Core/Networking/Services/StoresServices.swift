//
//  StoresServices.swift
//  El Buhonero
//
//  Created by Andrés Fonseca on 27/06/25.
//

import Foundation

protocol StoresServiceable {
    func getStoreAProducts() async -> Result<StoreAModel, RequestError>
    func getStoreBProducts() async -> Result<StoreBModel, RequestError>
}

class StoresServices: HTTPClient, StoresServiceable {
    func getStoreAProducts() async -> Result<StoreAModel, RequestError> {
        return await sendRequest(endpoint: StoresEndpoint.storeA, responseModel: StoreAModel.self)
    }
    
    func getStoreBProducts() async -> Result<StoreBModel, RequestError> {
        return await sendRequest(endpoint: StoresEndpoint.storeB, responseModel: StoreBModel.self)
    }
    

}
