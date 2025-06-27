//
//  HomeScreenViewModel.swift
//  El Buhonero
//
//  Created by Andrés Fonseca on 27/06/25.
//

import Foundation

struct HomeProduct {
    let id: Int
    let title: String
    let price: Double
    let imageUrl: String
    let category: String?
    let description: String?
}

enum HomeSection {
    case banner([HomeProduct])
    case category(name: String, products: [HomeProduct])
    case uncategorized(products: [HomeProduct])
}

class HomeScreenViewModel {
    private let dataManager = DataManager.shared
    private(set) var sections: [HomeSection] = []
    private(set) var allProducts: [HomeProduct] = []
    
    init() {
        loadProducts()
    }
    
    private func loadProducts() {
        switch dataManager.selectedCountry {
        case .countryA:
            let products = dataManager.storeAData.map {
                HomeProduct(
                    id: $0.id,
                    title: $0.title,
                    price: $0.price,
                    imageUrl: $0.image,
                    category: $0.category.rawValue,
                    description: $0.description
                )
            }
            allProducts = products
            buildSections(products: products)
        case .countryB:
            let products = dataManager.storeBData.map {
                HomeProduct(
                    id: $0.id,
                    title: $0.title,
                    price: Double($0.price),
                    imageUrl: $0.images.first ?? "",
                    category: $0.category.name,
                    description: $0.description
                )
            }
            allProducts = products
            buildSections(products: products)
        case .none:
            allProducts = []
            sections = []
        }
    }
    
    private func buildSections(products: [HomeProduct]) {
        // Banner: pick 5 random products
        let bannerProducts = Array(products.shuffled().prefix(5))
        var sections: [HomeSection] = [.banner(bannerProducts)]
        
        // Group by category if available
        let grouped = Dictionary(grouping: products) { $0.category ?? "Uncategorized" }
        for (category, items) in grouped.sorted(by: { $0.key < $1.key }) {
            // Show up to 4 products + 1 see more per category
            let preview = Array(items.prefix(4))
            sections.append(.category(name: category, products: preview))
        }
        self.sections = sections
    }
    
    func productsForSection(_ section: Int) -> [HomeProduct] {
        switch sections[section] {
        case .banner(let products):
            return products
        case .category(_, let products):
            return products
        case .uncategorized(let products):
            return products
        }
    }
    
    func sectionType(_ section: Int) -> HomeSection {
        return sections[section]
    }
    
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func numberOfItems(in section: Int) -> Int {
        switch sections[section] {
        case .banner(let products):
            return products.count
        case .category(_, let products):
            return products.count + 1 // +1 for See More
        case .uncategorized(let products):
            return products.count + 1
        }
    }
    
    func product(at indexPath: IndexPath) -> HomeProduct? {
        let section = sections[indexPath.section]
        switch section {
        case .banner(let products):
            return products[indexPath.item]
        case .category(_, let products), .uncategorized(let products):
            if indexPath.item < products.count {
                return products[indexPath.item]
            } else {
                return nil // See More cell
            }
        }
    }
    
    func isSeeMoreCell(at indexPath: IndexPath) -> Bool {
        let section = sections[indexPath.section]
        switch section {
        case .banner:
            return false
        case .category(_, let products), .uncategorized(let products):
            return indexPath.item == products.count
        }
    }
    
    func categoryName(for section: Int) -> String? {
        switch sections[section] {
        case .category(let name, _):
            return name
        default:
            return nil
        }
    }
    
    func reloadData() {
        loadProducts()
    }
} 
