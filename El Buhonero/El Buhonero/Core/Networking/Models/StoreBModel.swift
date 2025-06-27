//
//  StoreBModel.swift
//  El Buhonero
//
//  Created by Andrés Fonseca on 27/06/25.
//

import Foundation

// MARK: - StoreBModelElement
struct StoreBModelElement: Codable {
    let id: Int
    let title, slug: String
    let price: Int
    let description: String
    let category: BCategory
    let images: [String]
    let creationAt, updatedAt: String
}

// MARK: - Category
struct BCategory: Codable {
    let id: Int
    let name: Name
    let slug: Slug
    let image: String
    let creationAt, updatedAt: String
}

enum Name: String, Codable {
    case clothes = "Clothes"
    case electronics = "Electronics"
    case furniture = "Furniture"
    case many = "many"
    case miscellaneous = "Miscellaneous"
    case shoes = "Shoes"
}

enum Slug: String, Codable {
    case clothes = "clothes"
    case electronics = "electronics"
    case furniture = "furniture"
    case many = "many"
    case miscellaneous = "miscellaneous"
    case shoes = "shoes"
}

typealias StoreBModel = [StoreBModelElement]
