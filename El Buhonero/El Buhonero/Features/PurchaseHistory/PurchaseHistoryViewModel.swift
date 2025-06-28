//
//  PurchaseHistoryViewModel.swift
//  El Buhonero
//
//  Created by Andrés Fonseca on 27/06/25.
//

import Foundation
import SwiftUI

@MainActor
class PurchaseHistoryViewModel: ObservableObject {
    @Published var orders: [Order] = []
    @Published var showClearAllAlert = false
    
    func loadOrders() {
        orders = OrderManager.shared.getAllOrders()
    }
    
    func clearAllOrders() {
        OrderManager.shared.clearAllOrders()
        orders.removeAll()
    }
    
    func refreshOrders() {
        loadOrders()
    }
} 