//
//  ProductDetailViewModel.swift
//  El Buhonero
//
//  Created by Andrés Fonseca on 27/06/25.
//

import Foundation

protocol ProductDetailViewModelDelegate: AnyObject {
    func productLoaded(_ product: HomeProduct)
    func productLoadFailed(_ error: String)
    func loadingStateChanged(_ isLoading: Bool)
}

class ProductDetailViewModel {
    
    private var product: HomeProduct?
    private let dataManager = DataManager.shared
    private let storesService = StoresServices()
    
    weak var delegate: ProductDetailViewModelDelegate?
    
    init(product: HomeProduct) {
        self.product = product
    }

    init(productId: Int, country: String) {
        loadProductFromQR(productId: productId, country: country)
    }
    
    private func loadProductFromQR(productId: Int, country: String) {
        delegate?.loadingStateChanged(true)
        
        Task {
            let success = await fetchProductFromAPI(productId: productId, country: country)
            DispatchQueue.main.async {
                self.delegate?.loadingStateChanged(false)
                
                if success {
                    if let product = self.product {
                        self.delegate?.productLoaded(product)
                    } else {
                        self.delegate?.productLoadFailed("Product not found")
                    }
                } else {
                    self.delegate?.productLoadFailed("Failed to load product")
                }
            }
        }
    }
    
    private func fetchProductFromAPI(productId: Int, country: String) async -> Bool {
        // First check if we have the product in cache
        if let cachedProduct = getCachedProduct(productId: productId, country: country) {
            self.product = cachedProduct
            return true
        }
        
        // If not in cache, fetch from API
        switch country {
        case "A":
            let result = await storesService.getStoreAProducts()
            switch result {
            case .success(let products):
                dataManager.storeAData = products
                if let cachedProduct = getCachedProduct(productId: productId, country: country) {
                    self.product = cachedProduct
                    return true
                }
                return false
            case .failure:
                return false
            }
        case "B":
            let result = await storesService.getStoreBProducts()
            switch result {
            case .success(let products):
                dataManager.storeBData = products
                if let cachedProduct = getCachedProduct(productId: productId, country: country) {
                    self.product = cachedProduct
                    return true
                }
                return false
            case .failure:
                return false
            }
        default:
            return false
        }
    }
    
    private func getCachedProduct(productId: Int, country: String) -> HomeProduct? {
        switch country {
        case "A":
            return dataManager.storeAData.first { $0.id == productId }?.toHomeProduct()
        case "B":
            return dataManager.storeBData.first { $0.id == productId }?.toHomeProduct()
        default:
            return nil
        }
    }
    
    // MARK: - Product Data
    var productTitle: String {
        return product?.title ?? "Loading..."
    }
    
    var productPrice: String {
        guard let product = product else { return "Loading..." }
        return String(format: "$%.2f", product.price)
    }
    
    var productImageUrl: String {
        return product?.imageUrl ?? ""
    }
    
    var productDescription: String {
        return product?.description ?? "No description available."
    }
    
    var productCategory: String {
        return product?.category?.capitalized ?? "Uncategorized"
    }
    
    var productId: Int {
        return product?.id ?? 0
    }
    
    // MARK: - UI Configuration
    var navigationTitle: String {
        return product?.title ?? "Product Details"
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
    
    var hasProduct: Bool {
        return product != nil
    }
}

// MARK: - Extensions for API Models
extension StoreAModelElement {
    func toHomeProduct() -> HomeProduct {
        return HomeProduct(
            id: self.id,
            title: self.title,
            price: self.price,
            imageUrl: self.image,
            category: self.category.rawValue,
            description: self.description
        )
    }
}

extension StoreBModelElement {
    func toHomeProduct() -> HomeProduct {
        return HomeProduct(
            id: self.id,
            title: self.title,
            price: Double(self.price),
            imageUrl: self.images.first ?? "",
            category: self.category.name,
            description: self.description
        )
    }
} 
