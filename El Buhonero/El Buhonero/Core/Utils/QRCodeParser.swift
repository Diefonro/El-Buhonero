//
//  QRCodeParser.swift
//  El Buhonero
//
//  Created by Andrés Fonseca on 27/06/25.
//

import Foundation

struct QRCodeData: Codable {
    let country: String
    let productId: Int
}

enum QRCodeError: Error {
    case invalidFormat
    case invalidCountry
    case invalidProductId
    case decodingError
    
    var localizedDescription: String {
        switch self {
        case .invalidFormat:
            return "QR code format is invalid"
        case .invalidCountry:
            return "Invalid country code in QR"
        case .invalidProductId:
            return "Invalid product ID in QR"
        case .decodingError:
            return "Failed to decode QR code data"
        }
    }
}

class QRCodeParser {
    
    static func parseQRCode(_ qrString: String) -> Result<QRCodeData, QRCodeError> {
        // Remove any whitespace
        var cleanString = qrString.trimmingCharacters(in: .whitespacesAndNewlines)
        // Decode HTML entities (e.g., &#34; to ")
        cleanString = cleanString.replacingOccurrences(of: "&#34;", with: "\"")
        // Try to decode JSON
        guard let data = cleanString.data(using: .utf8) else {
            return .failure(.decodingError)
        }
        do {
            let qrData = try JSONDecoder().decode(QRCodeData.self, from: data)
            // Validate country
            guard qrData.country == "A" || qrData.country == "B" else {
                return .failure(.invalidCountry)
            }
            // Validate product ID
            guard qrData.productId > 0 else {
                return .failure(.invalidProductId)
            }
            return .success(qrData)
        } catch {
            return .failure(.invalidFormat)
        }
    }
    
    static func createQRString(country: String, productId: Int) -> String {
        let qrData = QRCodeData(country: country, productId: productId)
        
        do {
            let data = try JSONEncoder().encode(qrData)
            return String(data: data, encoding: .utf8) ?? ""
        } catch {
            return ""
        }
    }
} 