//
//  FavoriteDBStrategy.swift
//  EnesKendirciCaseStudy
//
//  Created by Enes KENDİRCİ on 20.05.2024.
//

import Foundation

protocol FavoriteDBStrategy {
    func add(product: Product) throws
    func delete(product: Product) throws
    func fetchAll() throws -> [Product]
    func toggle(product: Product) throws
}

extension FavoriteDBStrategy {
    func toggle(product: Product) throws {
        let products = try fetchAll()
        
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            try delete(product: products[index])
        } else {
            try add(product: product)
        }
    }
}
