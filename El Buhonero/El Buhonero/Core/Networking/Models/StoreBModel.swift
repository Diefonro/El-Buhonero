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
    let name: String
    let slug: String
    let image: String
    let creationAt, updatedAt: String
}

typealias StoreBModel = [StoreBModelElement]
