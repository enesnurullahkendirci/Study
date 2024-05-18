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

    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        viewModel = ProductListViewModel(networkManager: mockNetworkManager)
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
        XCTAssertEqual(viewModel.products.count, 2)
        XCTAssertEqual(viewModel.products[0].name, "Product 1")
        XCTAssertEqual(viewModel.products[1].name, "Product 2")
    }

    func testFetchProductsFailure() {
        // Given
        mockNetworkManager.jsonFileName = "invalidFileName"
        
        // When
        let expectation = self.expectation(description: "Fetch Products")
        viewModel.fetchProducts {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)

        // Then
        XCTAssertEqual(viewModel.products.count, 0)
    }
}
