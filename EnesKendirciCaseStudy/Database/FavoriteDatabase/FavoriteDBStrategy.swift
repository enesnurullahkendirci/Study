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
}
