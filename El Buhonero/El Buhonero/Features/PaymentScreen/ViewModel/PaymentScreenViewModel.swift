//
//  PaymentScreenViewModel.swift
//  El Buhonero
//
//  Created by Andrés Fonseca on 27/06/25.
//

import Foundation

protocol PaymentScreenViewModelDelegate: AnyObject {
    func paymentProcessing(_ isProcessing: Bool)
    func paymentSuccess()
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
                    self?.delegate?.paymentSuccess()
                case .failure(let error):
                    self?.delegate?.paymentFailed(error)
                }
            }
        }
    }
    
    func getValidTestCard() -> PaymentCard {
        return PaymentProcessor.getValidTestCard()
    }
} 