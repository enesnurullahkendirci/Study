//
//  CartViewModel.swift
//  EnesKendirciCaseStudy
//
//  Created by Enes KENDİRCİ on 20.05.2024.
//

import Foundation

final class CartViewModel {
    private var cartDB: CartDB
    private(set) var cartItems: [Product] = []
    var totalPrice: String {
        var total: Double = 0
        cartItems.forEach { product in
            if let price = product.price, let quantity = product.quantity, let price = Double(price) {
                total += price * Double(quantity)
            }
        }
        return "\(total)₺"
    }

    var onCartItemsChanged: (() -> Void)?

    init(cartDB: CartDB = CartDB(strategy: CoreDataCartDB())) {
        self.cartDB = cartDB
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func listenCartItems() {
        NotificationCenter.default.addObserver(self, selector: #selector(loadCartItems), name: Notification.Name("CartDBChange"), object: nil)
    }

    @objc func loadCartItems() {
        guard let cartItems = try? cartDB.fetchAll() else { return }
        
        self.cartItems = cartItems
        onCartItemsChanged?()
    }

    func increaseQuantity(of product: Product) {
        try? cartDB.insert(product: product)
    }

    func decreaseQuantity(of product: Product) {
        try? cartDB.delete(product: product)
    }

    func completePurchase() {
        // TODO: Implement purchase completion
    }
}
