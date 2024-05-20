//
//  MainTabBarViewModel.swift
//  EnesKendirciCaseStudy
//
//  Created by Enes KENDİRCİ on 20.05.2024.
//

import Foundation

final class MainTabBarViewModel {
    
    private var cartDB: CartDB
    var onCartItemsCountChange: ((String?) -> Void)?
    
    init(cartDB: CartDB = CartDB(strategy: CoreDataCartDB())) {
        self.cartDB = cartDB
        addObserverForCartDBChanges()
    }
    
    private func addObserverForCartDBChanges() {
        NotificationCenter.default.addObserver(self, selector: #selector(cartItemsChanged), name: .cartDBChange, object: nil)
    }
    
    @objc private func cartItemsChanged() {
        onCartItemsCountChange?(getCartItemsCount())
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func getCartItemsCount() -> String? {
        let count = try? cartDB.fetchAll().count
        if count == .zero {
            return nil
        } else {
            return count?.description
        }
    }
}
