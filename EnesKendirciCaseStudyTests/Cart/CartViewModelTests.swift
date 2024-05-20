//
//  CartViewModelTests.swift
//  EnesKendirciCaseStudyTests
//
//  Created by Enes KENDİRCİ on 20.05.2024.
//

import XCTest
@testable import EnesKendirciCaseStudy

class CartViewModelTests: XCTestCase {
    var viewModel: CartViewModel!
    var mockCartDB: CartDB!

    override func setUp() {
        super.setUp()
        let mockStrategy = MockCartDBStrategy()
        mockCartDB = CartDB(strategy: mockStrategy)
        viewModel = CartViewModel(cartDB: mockCartDB)
    }

    override func tearDown() {
        viewModel = nil
        mockCartDB = nil
        super.tearDown()
    }

    func testLoadCartItems() {
        let product1 = Product(id: "1", name: "Product 1", image: "image1", price: "100", description: "Description 1", model: "Model 1", brand: "Brand 1", createdAt: "2023-05-01", quantity: 1)
        let product2 = Product(id: "2", name: "Product 2", image: "image2", price: "200", description: "Description 2", model: "Model 2", brand: "Brand 2", createdAt: "2023-05-02", quantity: 1)
        
        try? mockCartDB.add(product: product1)
        try? mockCartDB.add(product: product2)

        viewModel.loadCartItems()

        XCTAssertEqual(viewModel.cartItems.count, 2)
        XCTAssertEqual(viewModel.cartItems[0].id, "1")
        XCTAssertEqual(viewModel.cartItems[1].id, "2")
    }

    func testIncreaseQuantity() {
        let product = Product(id: "1", name: "Product 1", image: "image1", price: "100", description: "Description 1", model: "Model 1", brand: "Brand 1", createdAt: "2023-05-01")
        
        viewModel.increaseQuantity(of: product)
        viewModel.loadCartItems()

        XCTAssertEqual(viewModel.cartItems[0].quantity, 1)
    }

    func testDecreaseQuantity() {
        let product = Product(id: "1", name: "Product 1", image: "image1", price: "100", description: "Description 1", model: "Model 1", brand: "Brand 1", createdAt: "2023-05-01", quantity: 2)
        
        viewModel.increaseQuantity(of: product)
        viewModel.decreaseQuantity(of: product)
        viewModel.loadCartItems()

        XCTAssertEqual(viewModel.cartItems.count, 0)
    }

    func testTotalPrice() {
        let product1 = Product(id: "1", name: "Product 1", image: "image1", price: "100", description: "Description 1", model: "Model 1", brand: "Brand 1", createdAt: "2023-05-01", quantity: 1)
        let product2 = Product(id: "2", name: "Product 2", image: "image2", price: "200", description: "Description 2", model: "Model 2", brand: "Brand 2", createdAt: "2023-05-02", quantity: 2)
        
        viewModel.increaseQuantity(of: product1)
        viewModel.increaseQuantity(of: product2)
        viewModel.increaseQuantity(of: product2)
        viewModel.loadCartItems()

        XCTAssertEqual(viewModel.totalPrice, "500.0₺")
    }
}
