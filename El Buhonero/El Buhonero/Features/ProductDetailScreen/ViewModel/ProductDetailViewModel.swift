//
//  ProductDetailViewModel.swift
//  El Buhonero
//
//  Created by Andrés Fonseca on 27/06/25.
//

import Foundation

class ProductDetailViewModel {
    
    private let product: HomeProduct
    
    init(product: HomeProduct) {
        self.product = product
    }
    
    // MARK: - Product Data
    var productTitle: String {
        return product.title
    }
    
    var productPrice: String {
        return String(format: "$%.2f", product.price)
    }
    
    var productImageUrl: String {
        return product.imageUrl
    }
    
    var productDescription: String {
        return product.description ?? "No description available."
    }
    
    var productCategory: String {
        return product.category?.capitalized ?? "Uncategorized"
    }
    
    var productId: Int {
        return product.id
    }
    
    // MARK: - UI Configuration
    var navigationTitle: String {
        return product.title
    }
    
    var formattedPrice: String {
        return productPrice
    }
    
    var formattedDescription: String {
        return productDescription
    }
    
    var categoryDisplayText: String {
        return "Category: \(productCategory)"
    }
    
    var idDisplayText: String {
        return "Product ID: \(productId)"
    }
} 