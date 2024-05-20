//
//  FavoriteDB.swift
//  EnesKendirciCaseStudy
//
//  Created by Enes KENDİRCİ on 20.05.2024.
//

import Foundation

class FavoriteDB: FavoriteDBStrategy {
    private var strategy: FavoriteDBStrategy

    init(strategy: FavoriteDBStrategy) {
        self.strategy = strategy
    }

    func setStrategy(_ strategy: FavoriteDBStrategy) {
        self.strategy = strategy
    }

    func add(product: Product) throws {
        try strategy.add(product: product)
    }

    func delete(product: Product) throws {
        try strategy.delete(product: product)
    }

    func fetchAll() throws -> [Product] {
        return try strategy.fetchAll()
    }

    func toggle(product: Product) throws {
        try strategy.toggle(product: product)
    }
}
