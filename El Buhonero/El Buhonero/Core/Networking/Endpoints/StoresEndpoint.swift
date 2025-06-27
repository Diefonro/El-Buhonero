//
//  StoresEndpoint.swift
//  El Buhonero
//
//  Created by Andrés Fonseca on 27/06/25.
//

import Foundation

enum StoresEndpoint {
    case storeA
    case storeB
}

extension StoresEndpoint: Endpoint {
    
    var host: String {
        switch self {
        case .storeA:
            return "fakestoreapi.com"
        case .storeB:
            return "api.escuelajs.co"
        }
    }
    
    var path: String {
        switch self {
        case .storeA:
            return "/products"
        case .storeB:
            return "/api/v1/products"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .storeA, .storeB:
            return nil
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .storeA, .storeB:
            return .get
        }
    }
    
    var header: [String : String]? {
        switch self {
        case .storeA, .storeB:
            return nil
        }
    }
    
    var body: Data? {
        switch self {
        case .storeA, .storeB:
            return nil
        }
    }
}
