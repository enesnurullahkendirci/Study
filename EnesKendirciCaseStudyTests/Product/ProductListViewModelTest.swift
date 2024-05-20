//
//  ProductListViewModelTest.swift
//  EnesKendirciCaseStudyTests
//
//  Created by Enes KENDİRCİ on 18.05.2024.
//

import XCTest
@testable import EnesKendirciCaseStudy

class ProductListViewModelTest: XCTestCase {
    
    var viewModel: ProductListViewModel!
    var mockNetworkManager: MockNetworkManager!
    var mockCartDB: CartDB!
    var mockFavoriteDB: FavoriteDB!
    
    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        mockCartDB = CartDB(strategy: MockCartDBStrategy())
        mockFavoriteDB = FavoriteDB(strategy: MockFavoriteDBStrategy())
        viewModel = ProductListViewModel(networkManager: mockNetworkManager, cartDB: mockCartDB, favoriteDB: mockFavoriteDB)
    }
    
    override func tearDown() {
        viewModel = nil
        mockNetworkManager = nil
        super.tearDown()
    }
    
    func testFetchProductsSuccess() {
        // Given
        mockNetworkManager.jsonFileName = "products"
        
        // When
        let expectation = self.expectation(description: "Fetch Products")
        viewModel.fetchProducts {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        // Then
        XCTAssertEqual(viewModel.numberOfItems, 2)
        XCTAssertEqual(viewModel.product(at: 0).name, "Product 1")
        XCTAssertEqual(viewModel.product(at: 1).name, "Product 2")
    }
    
    func testFilterProductsByBrand() {
        // Given
        mockNetworkManager.jsonFileName = "products"
        
        // When
        let expectation = self.expectation(description: "Filter Products by Brand")
        viewModel.fetchProducts {
            self.viewModel.applyFilters(selectedFilters: ["Brand": ["Brand 1"]], selectedSortOption: nil) {
                // Then
                XCTAssertEqual(self.viewModel.numberOfItems, 1)
                XCTAssertEqual(self.viewModel.product(at: 0).brand, "Brand 1")
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testSortProductsByPriceLowToHigh() {
        // Given
        mockNetworkManager.jsonFileName = "products"
        
        // When
        let expectation = self.expectation(description: "Sort Products by Price Low to High")
        viewModel.fetchProducts {
            self.viewModel.applyFilters(selectedFilters: [:], selectedSortOption: ProductListViewModel.SortOption.priceLowToHigh.rawValue) {
                // Then
                XCTAssertEqual(self.viewModel.numberOfItems, 2)
                XCTAssertEqual(self.viewModel.product(at: 0).price, "10.00")
                XCTAssertEqual(self.viewModel.product(at: 1).price, "20.00")
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testSearchProductsByName() {
        // Given
        mockNetworkManager.jsonFileName = "products"
        
        // When
        let expectation = self.expectation(description: "Search Products by Name")
        viewModel.fetchProducts {
            self.viewModel.filterProducts(by: "Product 1") {
                // Then
                XCTAssertEqual(self.viewModel.numberOfItems, 1)
                XCTAssertEqual(self.viewModel.product(at: 0).name, "Product 1")
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testSortOptionCases() {
        // Given
        let expectedSortOptions = [
            "Old to new",
            "New to old",
            "Price high to low",
            "Price low to high"
        ]
        
        // When
        let sortOptions = viewModel.sortOptionCases
        
        // Then
        XCTAssertEqual(sortOptions, expectedSortOptions)
    }
    
    func testGetFilterOptions() {
        // Given
        mockNetworkManager.jsonFileName = "products"
        
        // When
        let expectation = self.expectation(description: "Fetch Products")
        viewModel.fetchProducts {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        // Then
        let filterOptions = viewModel.getFilterOptions()
        XCTAssertEqual(filterOptions.count, 2)
        XCTAssertEqual(filterOptions[0]["Brand"], ["Brand 1", "Brand 2"])
        XCTAssertEqual(filterOptions[1]["Model"], ["Model 1", "Model 2"])
    }
    
    func testSortProducts() {
        // Given
        mockNetworkManager.jsonFileName = "products"
        
        // When
        let expectation = self.expectation(description: "Fetch and Sort Products")
        viewModel.fetchProducts {
            self.viewModel.applyFilters(selectedFilters: [:], selectedSortOption: ProductListViewModel.SortOption.oldToNew.rawValue) {
                // Then
                XCTAssertEqual(self.viewModel.product(at: 0).name, "Product 1")
                XCTAssertEqual(self.viewModel.product(at: 1).name, "Product 2")
                
                self.viewModel.applyFilters(selectedFilters: [:], selectedSortOption: ProductListViewModel.SortOption.newToOld.rawValue) {
                    XCTAssertEqual(self.viewModel.product(at: 0).name, "Product 2")
                    XCTAssertEqual(self.viewModel.product(at: 1).name, "Product 1")
                    
                    self.viewModel.applyFilters(selectedFilters: [:], selectedSortOption: ProductListViewModel.SortOption.priceHighToLow.rawValue) {
                        XCTAssertEqual(self.viewModel.product(at: 0).name, "Product 2")
                        XCTAssertEqual(self.viewModel.product(at: 1).name, "Product 1")
                        
                        self.viewModel.applyFilters(selectedFilters: [:], selectedSortOption: ProductListViewModel.SortOption.priceLowToHigh.rawValue) {
                            XCTAssertEqual(self.viewModel.product(at: 0).name, "Product 1")
                            XCTAssertEqual(self.viewModel.product(at: 1).name, "Product 2")
                            expectation.fulfill()
                        }
                    }
                }
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testAddToCart() {
        let product = Product(id: "1", name: "Product 1", image: "image1", price: "100", description: "Description 1", model: "Model 1", brand: "Brand 1", createdAt: "2023-05-01", quantity: 1)
        
        viewModel.addToCart(product: product)
        
        let cartItems = try? mockCartDB.fetchAll()
        XCTAssertEqual(cartItems?.count, 1)
        XCTAssertEqual(cartItems?.first?.id, product.id)
    }
    
    func testToggleFavorite() {
        let product = Product(id: "1", name: "Product 1", image: "image1", price: "100", description: "Description 1", model: "Model 1", brand: "Brand 1", createdAt: "2023-05-01", quantity: 1)
        
        viewModel.toggleFavorite(product: product)
        
        var favoriteProducts = try? mockFavoriteDB.fetchAll()
        XCTAssertEqual(favoriteProducts?.count, 1)
        XCTAssertEqual(favoriteProducts?.first?.id, product.id)
        
        viewModel.toggleFavorite(product: product)
        
        favoriteProducts = try? mockFavoriteDB.fetchAll()
        XCTAssertEqual(favoriteProducts?.count, 0)
    }
    
    func testIsFavorite() {
        let product = Product(id: "1", name: "Product 1", image: "image1", price: "100", description: "Description 1", model: "Model 1", brand: "Brand 1", createdAt: "2023-05-01", quantity: 1)
        
        viewModel.toggleFavorite(product: product)
        
        XCTAssertTrue(viewModel.isFavorite(product: product))
        
        viewModel.toggleFavorite(product: product)
        
        XCTAssertFalse(viewModel.isFavorite(product: product))
    }
    
    func testGetFavoriteProducts() {
        let product1 = Product(id: "1", name: "Product 1", image: "image1", price: "100", description: "Description 1", model: "Model 1", brand: "Brand 1", createdAt: "2023-05-01", quantity: 1)
        let product2 = Product(id: "2", name: "Product 2", image: "image2", price: "200", description: "Description 2", model: "Model 2", brand: "Brand 2", createdAt: "2023-05-02", quantity: 1)
        
        viewModel.toggleFavorite(product: product1)
        viewModel.toggleFavorite(product: product2)
        
        let favoriteProductIds = viewModel.getFavoriteProducts()
        XCTAssertEqual(favoriteProductIds.count, 2)
        XCTAssertTrue(favoriteProductIds.contains(product1.id ?? ""))
        XCTAssertTrue(favoriteProductIds.contains(product2.id ?? ""))
    }
}
