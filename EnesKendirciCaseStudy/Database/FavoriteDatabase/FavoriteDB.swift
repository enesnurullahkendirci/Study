//
//  FavoriteDB.swift
//  EnesKendirciCaseStudy
//
//  Created by Enes KENDİRCİ on 20.05.2024.
//

import Foundation

class FavoriteDB {
    private var strategy: FavoriteDBStrategy

    init(strategy: FavoriteDBStrategy) {
        self.strategy = strategy
    }

    func setStrategy(_ strategy: FavoriteDBStrategy) {
        self.strategy = strategy
    }

    func toggle(product: Product) throws {
        try strategy.toggle(product: product)
    }
    
    func fetchAll() throws -> [Product] {
        return try strategy.fetchAll()
    }
}
