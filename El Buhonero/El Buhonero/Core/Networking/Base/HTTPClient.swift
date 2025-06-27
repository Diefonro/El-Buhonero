//
//  HTTPClient.swift
//  El Buhonero
//
//  Created by Andrés Fonseca on 27/06/25.
//

import Foundation
import Alamofire

protocol HTTPClient {
    func sendRequest<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async -> Result<T, RequestError>
}

extension HTTPClient {
    func sendRequest<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async -> Result<T, RequestError> {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        urlComponents.queryItems = endpoint.queryItems
        print("sending request to url \(urlComponents.url?.absoluteString ?? "")")
        
        guard let url = urlComponents.url?.absoluteString.removingPercentEncoding else { return .failure(.invalidURL) }

        do {
            var urlRequest = try URLRequest(url: url.asURL())
            urlRequest.httpMethod = endpoint.method.rawValue
            urlRequest.allHTTPHeaderFields = endpoint.header

            if let body = endpoint.body {
                urlRequest.httpBody = body
            }

            // Configure session to avoid HTTP/3 issues
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 30
            configuration.timeoutIntervalForResource = 60
            // Disable HTTP/3 to avoid QUIC connection issues
            configuration.httpShouldUsePipelining = false
            configuration.httpMaximumConnectionsPerHost = 1
            
            let session = Session(configuration: configuration)
            
            let request = session.request(urlRequest).serializingDecodable(responseModel)
            
            guard let response = await request.response.response else {
                return .failure(.noResponse)
            }
            
            print("* * * * * * * * * ")
            urlRequest.printFullRequest()
            print(await request.response)
            print(await request.result)
            print("* * * * * * * * * ")
            print("JSON DATA: \(await String(data: request.response.data ?? Data(), encoding: .utf8) ?? "")")
            print("END JSON DATA * * * * * * * * * ")
            
            switch response.statusCode {
            case 200...299:
                guard let decodedResponse = try? await request.value else {
                    return .failure(.decode)
                }
                
                return .success(decodedResponse)
            case 401:
                return .failure(.unauthorized)
            default:
                print("Response status code: \(response.statusCode)")
                return .failure(.unexpectedStatusCode)
            }
        } catch {
            return .failure(.unknown)
        }
    }
}

extension URLRequest {
    func printFullRequest() {
        let method = self.httpMethod ?? ""
        let url = self.url ?? URL(string: "")!
        print("\n\(method) : \(url)")
        if let headers = self.allHTTPHeaderFields {
            print("\nHEADERS :")
            for (value, key) in headers {
                print("\n\(value) : \(key)")
            }
        }
        
        if let body = String(data: self.httpBody ?? Data(), encoding: .utf8) {
            print("\nBODY : \(body) \n")
        }
    }
}
