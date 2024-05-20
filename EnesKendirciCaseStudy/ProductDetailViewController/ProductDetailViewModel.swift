//
//  ProductDetailViewModel.swift
//  EnesKendirciCaseStudy
//
//  Created by Enes KENDİRCİ on 20.05.2024.
//

import Foundation

final class ProductDetailViewModel {
    
    private var cartDB: CartDB
    var onCartItemsCountChange: ((String?) -> Void)?
    
    init(cartDB: CartDB = CartDB(strategy: CoreDataCartDB())) {
        self.cartDB = cartDB
    }
    
    func addToCart(product: Product) {
        try? cartDB.insert(product: product)
    }
}
