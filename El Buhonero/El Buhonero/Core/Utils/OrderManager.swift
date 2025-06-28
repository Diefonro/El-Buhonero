//
//  OrderManager.swift
//  El Buhonero
//
//  Created by Andrés Fonseca on 27/06/25.
//

import Foundation

struct Order {
    let orderNumber: String
    let productTitle: String
    let productPrice: Double
    let productImageURL: String
    let cardLastFourDigits: String
    let transactionDate: Date
    let status: OrderStatus
}

enum OrderStatus: String, Codable {
    case completed = "completed"
    case pending = "pending"
    case failed = "failed"
}

class OrderManager {
    static let shared = OrderManager()
    
    private let userDefaults = UserDefaults.standard
    private let ordersKey = "saved_orders"
    
    private init() {}
    
    // Generate a unique order number
    func generateOrderNumber() -> String {
        let timestamp = Int(Date().timeIntervalSince1970)
        let randomSuffix = String(format: "%04d", Int.random(in: 1000...9999))
        return "ORD-\(timestamp)-\(randomSuffix)"
    }
    
    // Save a new order
    func saveOrder(_ order: Order) {
        var orders = getAllOrders()
        orders.append(order)
        saveOrders(orders)
    }
    
    // Get all saved orders
    func getAllOrders() -> [Order] {
        guard let data = userDefaults.data(forKey: ordersKey),
              let orders = try? JSONDecoder().decode([Order].self, from: data) else {
            return []
        }
        return orders.sorted { $0.transactionDate > $1.transactionDate } // Most recent first
    }
    
    // Save orders to UserDefaults
    private func saveOrders(_ orders: [Order]) {
        if let data = try? JSONEncoder().encode(orders) {
            userDefaults.set(data, forKey: ordersKey)
        }
    }
    
    // Get last 4 digits of card number
    func getLastFourDigits(from cardNumber: String) -> String {
        let cleanNumber = cardNumber.replacingOccurrences(of: " ", with: "")
        if cleanNumber.count >= 4 {
            return String(cleanNumber.suffix(4))
        }
        return "****"
    }
    
    // Clear all orders (for testing purposes)
    func clearAllOrders() {
        userDefaults.removeObject(forKey: ordersKey)
    }
}

// MARK: - Codable Extensions
extension Order: Codable {
    enum CodingKeys: String, CodingKey {
        case orderNumber
        case productTitle
        case productPrice
        case productImageURL
        case cardLastFourDigits
        case transactionDate
        case status
    }
} 