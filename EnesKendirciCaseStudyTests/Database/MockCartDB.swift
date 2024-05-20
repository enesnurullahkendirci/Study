//
//  MockCartDB.swift
//  EnesKendirciCaseStudyTests
//
//  Created by Enes KENDİRCİ on 20.05.2024.
//

import Foundation
@testable import EnesKendirciCaseStudy

class MockCartDBStrategy: CartDBStrategy {
    private var items: [Product] = []

    func add(product: Product) throws {
        items.append(product)
    }

    func update(product: Product) throws {
        if let index = items.firstIndex(where: { $0.id == product.id }) {
            items[index] = product
        }
    }

    func delete(product: Product) throws {
        items.removeAll { $0.id == product.id }
    }

    func fetchAll() throws -> [Product] {
        return items
    }
}
