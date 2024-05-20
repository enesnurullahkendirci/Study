//
//  CartDB.swift
//  EnesKendirciCaseStudy
//
//  Created by Enes KENDİRCİ on 20.05.2024.
//

import Foundation

class CartDB {
    private var strategy: CartDBStrategy

    init(strategy: CartDBStrategy) {
        self.strategy = strategy
    }

    func setStrategy(_ strategy: CartDBStrategy) {
        self.strategy = strategy
    }

    func insert(product: Product) throws {
        var products = try strategy.fetchAll()
        
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            var existingProduct = products[index]
            existingProduct.quantity = (existingProduct.quantity ?? 0) + 1
            try strategy.update(product: existingProduct)
        } else {
            var newProduct = product
            newProduct.quantity = 1
            try strategy.add(product: newProduct)
        }
        
        NotificationCenter.default.post(name: Notification.Name("CartDBChange"), object: nil)
    }

    func delete(product: Product) throws {
        var products = try strategy.fetchAll()
        
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            var existingProduct = products[index]
            if existingProduct.quantity ?? 0 > 1 {
                existingProduct.quantity = (existingProduct.quantity ?? 0) - 1
                try strategy.update(product: existingProduct)
            } else {
                try strategy.delete(product: existingProduct)
            }
        }
        
        NotificationCenter.default.post(name: Notification.Name("CartDBChange"), object: nil)
    }

    func fetchAll() throws -> [Product] {
        return try strategy.fetchAll()
    }
}
