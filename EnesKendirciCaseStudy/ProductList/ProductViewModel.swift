//
//  ProductViewModel.swift
//  EnesKendirciCaseStudy
//
//  Created by Enes KENDİRCİ on 18.05.2024.
//

import Foundation

final class ProductListViewModel {
    private let networkManager: NetworkManagerProtocol
    private let cartDB: CartDB
    private let favoriteDB: FavoriteDB
    private var products: [Product] = []
    private var filteredProducts: [Product] = []
    
    private var selectedFilters: [String: [String]] = [:]
    private var selectedSortOption: SortOption?
    private var searchText: String = ""
    
    enum SortOption: String, CaseIterable {
        case oldToNew = "Old to new"
        case newToOld = "New to old"
        case priceHighToLow = "Price high to low"
        case priceLowToHigh = "Price low to high"
    }
    
    var sortOptionCases: [String] {
        return SortOption.allCases.map { $0.rawValue }
    }
    
    init(
        networkManager: NetworkManagerProtocol = NetworkManager.shared,
        cartDB: CartDB = CartDB(strategy: CoreDataCartDB()),
        favoriteDB: FavoriteDB = FavoriteDB(strategy: CoreDataFavoriteDB())
    ) {
        self.networkManager = networkManager
        self.cartDB = cartDB
        self.favoriteDB = favoriteDB
    }
    
    var numberOfItems: Int {
        return filteredProducts.count
    }
    
    func product(at index: Int) -> Product {
        return filteredProducts[index]
    }
    
    func fetchProducts(completion: @escaping () -> Void) {
        let request = ProductRequest()
        networkManager.fetch(request) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let products):
                    self?.products = products
                    self?.applyFiltersAndSearch(completion: completion)
                case .failure(let error):
                    print("Error fetching products: \(error)")
                    // TODO: Handle error
                    completion()
                }
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
    
    private func filterProducts() {
        filteredProducts = products.filter { product in
            var matches = true
            
            if let selectedBrands = selectedFilters["Brand"], !selectedBrands.isEmpty {
                matches = matches && selectedBrands.contains(product.brand ?? "")
            }
            
            if let selectedModels = selectedFilters["Model"], !selectedModels.isEmpty {
                matches = matches && selectedModels.contains(product.model ?? "")
            }
            
            if !searchText.isEmpty {
                matches = matches && (product.name?.lowercased().contains(searchText.lowercased()) ?? false)
            }
            
            return matches
        }
    }
    
    private func sortProducts() {
        guard let sortOption = selectedSortOption else { return }
        
        switch sortOption {
        case .oldToNew:
            filteredProducts.sort { product1, product2 in
                if let date1 = product1.createdAt?.toDate(), let date2 = product2.createdAt?.toDate() {
                    return date1 < date2
                }
                return false
            }
        case .newToOld:
            filteredProducts.sort { product1, product2 in
                if let date1 = product1.createdAt?.toDate(), let date2 = product2.createdAt?.toDate() {
                    return date1 > date2
                }
                return false
            }
        case .priceHighToLow:
            filteredProducts.sort { product1, product2 in
                if let price1 = Double(product1.price ?? ""), let price2 = Double(product2.price ?? "") {
                    return price1 > price2
                }
                return false
            }
        case .priceLowToHigh:
            filteredProducts.sort { product1, product2 in
                if let price1 = Double(product1.price ?? ""), let price2 = Double(product2.price ?? "") {
                    return price1 < price2
                }
                return false
            }
        }
    }
    
    private func applyFiltersAndSearch(completion: @escaping () -> Void) {
        filterProducts()
        sortProducts()
        completion()
    }
    
    func applyFilters(selectedFilters: [String: [String]], selectedSortOption: String?, completion: @escaping () -> Void) {
        self.selectedFilters = selectedFilters
        self.selectedSortOption = SortOption(rawValue: selectedSortOption ?? "")
        applyFiltersAndSearch(completion: completion)
    }
    
    func filterProducts(by searchText: String, completion: @escaping () -> Void) {
        self.searchText = searchText
        applyFiltersAndSearch(completion: completion)
    }
    
    func addToCart(product: Product) {
        try? cartDB.addToCart(product: product)
    }
    
    func toggleFavorite(product: Product) {
        try? favoriteDB.toggle(product: product)
    }
    
    func isFavorite(product: Product) -> Bool {
        let favoriteProducts = getFavoriteProducts()
        return favoriteProducts.contains(product.id ?? "")
    }
    
    func getFavoriteProducts() -> [String] {
        guard let favoriteProducts = try? favoriteDB.fetchAll() else { return [] }
        return favoriteProducts.compactMap { $0.id }
    }
}
