//
//  Product.swift
//  EnesKendirciCaseStudy
//
//  Created by Enes KENDİRCİ on 18.05.2024.
//

import Foundation

struct Product: Codable {
    let id: String?
    let name: String?
    let image: String?
    let price: Double?
    let description: String?
    let model: String?
    let brand: String?
    let createdAt: Date?
}
