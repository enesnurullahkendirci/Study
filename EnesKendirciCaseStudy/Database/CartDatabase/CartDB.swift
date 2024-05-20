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
        try strategy.insert(product: product)
    }

    func delete(product: Product) throws {
        try strategy.delete(product: product)
    }

    func fetchAll() throws -> [Product] {
        return try strategy.fetchAll()
    }
}
