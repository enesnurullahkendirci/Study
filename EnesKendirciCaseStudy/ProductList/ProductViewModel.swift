//
//  ProductViewModel.swift
//  EnesKendirciCaseStudy
//
//  Created by Enes KENDİRCİ on 18.05.2024.
//

import Foundation

final class ProductListViewModel {
    private let networkManager: NetworkManagerProtocol
    var products: [Product] = []
    
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func fetchProducts(completion: @escaping () -> Void) {
        let request = ProductRequest()
        networkManager.fetch(request) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let products):
                    self?.products = products
                case .failure(let error):
                    print("Error fetching products: \(error)")
                    // TODO: Handle error
                }
                completion()
            }
        }
    }
    
    func getFilterOptions() -> [[String: [String]]] {
        var brands: Set<String> = []
        var models: Set<String> = []
        
        for product in products {
            if let brand = product.brand {
                brands.insert(brand)
            }
            if let model = product.model {
                models.insert(model)
            }
        }
        
        let brandArray = Array(brands).sorted()
        let modelArray = Array(models).sorted()
        
        return [["Brand": brandArray], ["Model": modelArray]]
    }
}
