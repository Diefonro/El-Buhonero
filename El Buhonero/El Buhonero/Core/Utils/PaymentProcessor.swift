//
//  PaymentProcessor.swift
//  El Buhonero
//
//  Created by Andrés Fonseca on 27/06/25.
//

import Foundation

struct PaymentCard {
    let number: String
    let cvv: String
    let expirationMonth: String
    let expirationYear: String
}

enum PaymentError: Error {
    case invalidCardNumber
    case invalidCVV
    case invalidExpiration
    case paymentDeclined
    case networkError
    
    var localizedDescription: String {
        switch self {
        case .invalidCardNumber:
            return "Invalid card number"
        case .invalidCVV:
            return "Invalid CVV"
        case .invalidExpiration:
            return "Invalid expiration date"
        case .paymentDeclined:
            return "Payment was declined. Please try with a valid card."
        case .networkError:
            return "Network error. Please try again."
        }
    }
}

class PaymentProcessor {
    
    // Valid test card for demonstration
    private static let validCardNumber = "4111111111111111"
    private static let validCVV = "123"
    private static let validExpirationMonth = "12"
    private static let validExpirationYear = "25"
    
    static func processPayment(card: PaymentCard, amount: Double) async -> Result<Bool, PaymentError> {
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
        
        // Validate card number
        guard isValidCardNumber(card.number) else {
            return .failure(.invalidCardNumber)
        }
        
        // Validate CVV
        guard isValidCVV(card.cvv) else {
            return .failure(.invalidCVV)
        }
        
        // Validate expiration
        guard isValidExpiration(month: card.expirationMonth, year: card.expirationYear) else {
            return .failure(.invalidExpiration)
        }
        
        // Check if it's the valid test card
        if card.number == validCardNumber && 
           card.cvv == validCVV && 
           card.expirationMonth == validExpirationMonth && 
           card.expirationYear == validExpirationYear {
            return .success(true)
        } else {
            return .failure(.paymentDeclined)
        }
    }
    
    private static func isValidCardNumber(_ number: String) -> Bool {
        let cleanNumber = number.replacingOccurrences(of: " ", with: "")
        return cleanNumber.count >= 13 && cleanNumber.count <= 19 && cleanNumber.allSatisfy { $0.isNumber }
    }
    
    private static func isValidCVV(_ cvv: String) -> Bool {
        return cvv.count >= 3 && cvv.count <= 4 && cvv.allSatisfy { $0.isNumber }
    }
    
    private static func isValidExpiration(month: String, year: String) -> Bool {
        guard let monthInt = Int(month), let yearInt = Int(year) else {
            return false
        }
        
        let currentDate = Date()
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: currentDate) % 100 // Last 2 digits
        let currentMonth = calendar.component(.month, from: currentDate)
        
        // Check if expiration is in the future
        if yearInt < currentYear {
            return false
        }
        
        if yearInt == currentYear && monthInt < currentMonth {
            return false
        }
        
        return monthInt >= 1 && monthInt <= 12
    }
    
    // Helper method to get valid test card info
    static func getValidTestCard() -> PaymentCard {
        return PaymentCard(
            number: validCardNumber,
            cvv: validCVV,
            expirationMonth: validExpirationMonth,
            expirationYear: validExpirationYear
        )
    }
} 