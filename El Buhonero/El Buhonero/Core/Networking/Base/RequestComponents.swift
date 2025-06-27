//
//  RequestComponents.swift
//  El Buhonero
//
//  Created by Andrés Fonseca on 27/06/25.
//

import Foundation

enum RequestMethod: String {
    case delete = "DELETE"
    case get = "GET"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
}

enum RequestError: Error {
    case decode
    case invalidURL
    case noResponse
    case unauthorized
    case unexpectedStatusCode
    case unknown
    case networkError(Error)
    
    var message: String {
        switch self {
        case .decode:
            return "Decode"
        case .invalidURL:
            return "Invalid URL"
        case .noResponse:
            return "No Response"
        case .unauthorized:
            return "Unauthorized"
        case .unexpectedStatusCode:
            return "Unexpected Status Code"
        case .unknown:
            return "Unknown"
        case .networkError:
            return "networkError"
        }
    }
    
    var description: String {
        switch self {
        default:
            return "..."
        }
    }
}

enum AppError: Error {
    case serviceError(RequestError)
    case unknownError(Error)
    
    var description: String {
        switch self {
        case .serviceError(let serviceError):
            return "Service error: \(serviceError)"
        case .unknownError(let error):
            return "Unknown error: \(error)"
        }
    }
    
    static func handle(error: Error) {
        switch error {
        case let serviceError as RequestError:
            let appError = AppError.serviceError(serviceError)
            print(appError.description)
        default:
            let appError = AppError.unknownError(error)
            print(appError.description)
        }
    }
}
