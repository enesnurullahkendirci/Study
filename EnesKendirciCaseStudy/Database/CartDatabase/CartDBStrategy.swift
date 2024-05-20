//
//  CartDBStrategy.swift
//  EnesKendirciCaseStudy
//
//  Created by Enes KENDİRCİ on 20.05.2024.
//

import Foundation

protocol CartDBStrategy {
    func add(product: Product) throws
    func update(product: Product) throws
    func delete(product: Product) throws
    func fetchAll() throws -> [Product]
    func addToCart(product: Product) throws
    func removeFromCart(product: Product) throws
}

extension CartDBStrategy {
    func addToCart(product: Product) throws {
        let products = try fetchAll()
        
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            var existingProduct = products[index]
            existingProduct.quantity = (existingProduct.quantity ?? 0) + 1
            try update(product: existingProduct)
        } else {
            var newProduct = product
            newProduct.quantity = 1
            try add(product: newProduct)
        }
        
        NotificationCenter.default.post(name: .cartDBChange, object: nil)
    }
    
    func removeFromCart(product: Product) throws {
        let products = try fetchAll()
        
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            var existingProduct = products[index]
            if existingProduct.quantity ?? 0 > 1 {
                existingProduct.quantity = (existingProduct.quantity ?? 0) - 1
                try update(product: existingProduct)
            } else {
                try delete(product: existingProduct)
            }
        }
        
        NotificationCenter.default.post(name: .cartDBChange, object: nil)
    }
}
