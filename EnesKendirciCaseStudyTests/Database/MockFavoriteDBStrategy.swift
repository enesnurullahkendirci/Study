//
//  MockFavoriteDBStrategy.swift
//  EnesKendirciCaseStudyTests
//
//  Created by Enes KENDİRCİ on 20.05.2024.
//

import Foundation
@testable import EnesKendirciCaseStudy

class MockFavoriteDBStrategy: FavoriteDBStrategy {
    private var items: [Product] = []

    func add(product: Product) throws {
        items.append(product)
    }

    func delete(product: Product) throws {
        items.removeAll { $0.id == product.id }
    }

    func fetchAll() throws -> [Product] {
        return items
    }
}
