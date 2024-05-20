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

    func add(product: Product) throws {
        try strategy.add(product: product)
    }

    func update(product: Product) throws {
        try strategy.update(product: product)
    }

    func delete(product: Product) throws {
        try strategy.delete(product: product)
    }

    func fetchAll() throws -> [Product] {
        return try strategy.fetchAll()
    }

    func addToCart(product: Product) throws {
        try strategy.addToCart(product: product)
    }

    func removeFromCart(product: Product) throws {
        try strategy.removeFromCart(product: product)
    }
}
