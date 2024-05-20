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
        let products = try strategy.fetchAll()
        
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            try strategy.delete(product: products[index])
        } else {
            try strategy.add(product: product)
        }
        
        NotificationCenter.default.post(name: Notification.Name("FavoriteDBChange"), object: nil)
    }

    func fetchAll() throws -> [Product] {
        return try strategy.fetchAll()
    }
}
