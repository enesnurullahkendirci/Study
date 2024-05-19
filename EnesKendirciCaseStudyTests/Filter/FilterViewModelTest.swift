//
//  FilterViewModelTest.swift
//  EnesKendirciCaseStudyTests
//
//  Created by Enes KENDİRCİ on 20.05.2024.
//

import XCTest
@testable import EnesKendirciCaseStudy

final class FilterViewModelTests: XCTestCase {
    
    var viewModel: FilterViewModel!
    
    override func setUp() {
        super.setUp()
        let filterOptions: [[String: [String]]] = [
            ["Color": ["Red", "Green", "Blue"]],
            ["Size": ["Small", "Medium", "Large"]]
        ]
        let sortOptions = ["Price: Low to High", "Price: High to Low", "Newest"]
        viewModel = FilterViewModel(filterOptions: filterOptions, sortOptions: sortOptions)
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testNumberOfRowsInSection() {
        XCTAssertEqual(viewModel.numberOfRows(in: 0), 3) // sortOptions count
        XCTAssertEqual(viewModel.numberOfRows(in: 1), 3) // Color options count
        XCTAssertEqual(viewModel.numberOfRows(in: 2), 3) // Size options count
    }
    
    func testOptionAtIndexPath() {
        XCTAssertEqual(viewModel.option(at: IndexPath(row: 0, section: 0)), "Price: Low to High")
        XCTAssertEqual(viewModel.option(at: IndexPath(row: 1, section: 1)), "Green")
        XCTAssertEqual(viewModel.option(at: IndexPath(row: 2, section: 2)), "Large")
    }
    
    func testIsSelectedAtIndexPath() {
        XCTAssertFalse(viewModel.isSelected(at: IndexPath(row: 0, section: 0)))
        XCTAssertFalse(viewModel.isSelected(at: IndexPath(row: 1, section: 1)))
        XCTAssertFalse(viewModel.isSelected(at: IndexPath(row: 2, section: 2)))
    }
    
    func testSelectOptionAtIndexPath() {
        let indexPath = IndexPath(row: 0, section: 0)
        viewModel.selectOption(at: indexPath)
        XCTAssertTrue(viewModel.isSelected(at: indexPath))
        XCTAssertEqual(viewModel.selectedSortOption, "Price: Low to High")
        
        let colorIndexPath = IndexPath(row: 1, section: 1)
        viewModel.selectOption(at: colorIndexPath)
        XCTAssertTrue(viewModel.isSelected(at: colorIndexPath))
        XCTAssertEqual(viewModel.selectedFilter["Color"], ["Green"])
    }
    
    func testDeselectOptionAtIndexPath() {
        let colorIndexPath = IndexPath(row: 1, section: 1)
        viewModel.selectOption(at: colorIndexPath)
        viewModel.selectOption(at: colorIndexPath)
        XCTAssertFalse(viewModel.isSelected(at: colorIndexPath))
        XCTAssertNil(viewModel.selectedFilter["Color"])
    }
    
    func testSearchFilter() {
        viewModel.searchFilter(for: "Re", in: 1)
        XCTAssertEqual(viewModel.numberOfRows(in: 1), 2)
        XCTAssertEqual(viewModel.option(at: IndexPath(row: 0, section: 1)), "Red")
        
        viewModel.searchFilter(for: "S", in: 2)
        XCTAssertEqual(viewModel.numberOfRows(in: 2), 1)
        XCTAssertEqual(viewModel.option(at: IndexPath(row: 0, section: 2)), "Small")
    }
}
