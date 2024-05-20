//
//  ProductViewModel.swift
//  EnesKendirciCaseStudy
//
//  Created by Enes KENDİRCİ on 18.05.2024.
//

import Foundation

final class ProductListViewModel {
    private let networkManager: NetworkManagerProtocol
    private var products: [Product] = []
    private var filteredProducts: [Product] = []
    
    let sortOptions = ["Old to new", "New to old", "Price high to low", "Price low to high"]
    
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    var numberOfItems: Int {
        if filteredProducts.isEmpty {
            return products.count
        } else {
            return filteredProducts.count
        }
    }
    
    func product(at index: Int) -> Product {
        if filteredProducts.isEmpty {
            return products[index]
        } else {
            return filteredProducts[index]
        }
    }
    
    func fetchProducts(completion: @escaping () -> Void) {
        let request = ProductRequest()
        networkManager.fetch(request) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let products):
                    self?.products = products
                    self?.filteredProducts = products
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
    
    func applyFilters(selectedFilters: [String : [String]], selectedSortOptions: String?, completion: @escaping () -> Void) {
        filteredProducts = products.filter { product in
            var matches = true
            
            if let selectedBrands = selectedFilters["Brand"], !selectedBrands.isEmpty {
                matches = matches && selectedBrands.contains(product.brand ?? "")
            }
            
            if let selectedModels = selectedFilters["Model"], !selectedModels.isEmpty {
                matches = matches && selectedModels.contains(product.model ?? "")
            }
            
            return matches
        }
        
        if let sortOption = selectedSortOptions {
            switch sortOption {
            case "Old to new":
                filteredProducts.sort { product1, product2 in
                    if let date1 = product1.createdAt?.toDate(), let date2 = product2.createdAt?.toDate() {
                        return date1 < date2
                    }
                    return false
                }
            case "New to old":
                filteredProducts.sort { product1, product2 in
                    if let date1 = product1.createdAt?.toDate(), let date2 = product2.createdAt?.toDate() {
                        return date1 > date2
                    }
                    return false
                }
            case "Price high to low":
                filteredProducts.sort { product1, product2 in
                    if let price1 = Double(product1.price ?? ""), let price2 = Double(product2.price ?? "") {
                        return price1 > price2
                    }
                    return false
                }
            case "Price low to high":
                filteredProducts.sort { product1, product2 in
                    if let price1 = Double(product1.price ?? ""), let price2 = Double(product2.price ?? "") {
                        return price1 < price2
                    }
                    return false
                }
            default:
                break
            }
        }
        
        completion()
    }
}
