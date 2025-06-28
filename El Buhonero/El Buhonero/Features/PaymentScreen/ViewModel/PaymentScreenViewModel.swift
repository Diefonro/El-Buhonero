//
//  PaymentScreenViewModel.swift
//  El Buhonero
//
//  Created by Andrés Fonseca on 27/06/25.
//

import Foundation

protocol PaymentScreenViewModelDelegate: AnyObject {
    func paymentProcessing(_ isProcessing: Bool)
    func paymentSuccess(orderNumber: String)
    func paymentFailed(_ error: PaymentError)
}

class PaymentScreenViewModel {
    
    private let product: HomeProduct
    
    weak var delegate: PaymentScreenViewModelDelegate?
    
    private(set) var isProcessing = false
    
    init(product: HomeProduct) {
        self.product = product
    }
    
    var productTitle: String {
        return product.title
    }
    
    var productPrice: String {
        return product.formattedPrice
    }
    
    var totalAmount: Double {
        return product.price
    }
    
    func processPayment(card: PaymentCard) {
        guard !isProcessing else { return }
        
        isProcessing = true
        delegate?.paymentProcessing(true)
        
        Task {
            let result = await PaymentProcessor.processPayment(card: card, amount: totalAmount)
            
            DispatchQueue.main.async { [weak self] in
                self?.isProcessing = false
                self?.delegate?.paymentProcessing(false)
                
                switch result {
                case .success:
                    self?.saveOrder(card: card)
                case .failure(let error):
                    self?.delegate?.paymentFailed(error)
                }
            }
        }
    }
    
    private func saveOrder(card: PaymentCard) {
        let orderNumber = OrderManager.shared.generateOrderNumber()
        let lastFourDigits = OrderManager.shared.getLastFourDigits(from: card.number)
        
        let order = Order(
            orderNumber: orderNumber,
            productTitle: productTitle,
            productPrice: totalAmount,
            productImageURL: product.imageUrl,
            cardLastFourDigits: lastFourDigits,
            transactionDate: Date(),
            status: .completed
        )
        
        OrderManager.shared.saveOrder(order)
        
        print("💾 Order saved: \(orderNumber)")
        print("   Product: \(productTitle)")
        print("   Amount: $\(totalAmount)")
        print("   Image: \(product.imageUrl)")
        print("   Card: ****\(lastFourDigits)")
        print("   Date: \(order.transactionDate)")
        
        delegate?.paymentSuccess(orderNumber: orderNumber)
    }
    
    func getValidTestCard() -> PaymentCard {
        return PaymentProcessor.getValidTestCard()
    }
} 
