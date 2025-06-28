//
//  PurchaseHistoryView.swift
//  El Buhonero
//
//  Created by Andrés Fonseca on 27/06/25.
//

import SwiftUI

struct PurchaseHistoryView: View {
    @StateObject private var viewModel = PurchaseHistoryViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Color(red: 0.047, green: 0.047, blue: 0.047)
                    .ignoresSafeArea()
                
                if viewModel.orders.isEmpty {
                    // Empty state
                    VStack(spacing: 20) {
                        Image(systemName: "bag.badge.plus")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text("No Purchase History")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        Text("Complete a purchase to see your order history here.")
                            .font(.body)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.orders, id: \.orderNumber) { order in
                                PurchaseHistoryCard(order: order)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                    }
                }
            }
            .navigationTitle("Purchase History")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Clear All") {
                        viewModel.showClearAllAlert = true
                    }
                    .foregroundColor(.red)
                }
            }
        }
        .onAppear {
            viewModel.loadOrders()
        }
        .alert("Clear All Purchases", isPresented: $viewModel.showClearAllAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Clear All", role: .destructive) {
                viewModel.clearAllOrders()
            }
        } message: {
            Text("Are you sure you want to clear all purchase history? This action cannot be undone.")
        }
    }
}

struct PurchaseHistoryCard: View {
    let order: Order
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with order number and status
            HStack {
                Text("Order: \(order.orderNumber)")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                
                Spacer()
                
                StatusBadge(status: order.status)
            }
            
            // Product info
            HStack(spacing: 12) {
                // Product image
                AsyncImage(url: URL(string: order.productImageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                        )
                }
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                
                // Product details
                VStack(alignment: .leading, spacing: 4) {
                    Text(order.productTitle)
                        .font(.headline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .lineLimit(2)
                    
                    Text("$\(String(format: "%.2f", order.productPrice))")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }
                
                Spacer()
            }
            
            // Transaction details
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Card: ****\(order.cardLastFourDigits)")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text(formatDate(order.transactionDate))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(red: 0.1, green: 0.1, blue: 0.1))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct StatusBadge: View {
    let status: OrderStatus
    
    var body: some View {
        Text(status.rawValue.capitalized)
            .font(.caption2)
            .fontWeight(.semibold)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(statusColor)
            )
            .foregroundColor(.white)
    }
    
    private var statusColor: Color {
        switch status {
        case .completed:
            return .green
        case .pending:
            return .orange
        case .failed:
            return .red
        }
    }
}

#Preview {
    PurchaseHistoryView()
} 
