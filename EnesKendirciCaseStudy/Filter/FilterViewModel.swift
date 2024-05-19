//
//  FilterViewModel.swift
//  EnesKendirciCaseStudy
//
//  Created by Enes KENDİRCİ on 19.05.2024.
//

import Foundation

final class FilterViewModel {
    var filterOptions: [[String: [String]]]
    private(set) var selectedSortOption: String?
    private(set) var selectedFilter: [String: [String]] = [:]
    
    var sortOptions: [String] = []

    init(filterOptions: [[String: [String]]], sortOptions: [String]) {
        self.filterOptions = filterOptions
        self.sortOptions = sortOptions
    }

    func numberOfSections() -> Int {
        return filterOptions.count + 1
    }

    func numberOfRows(in section: Int) -> Int {
        if section == 0 {
            return sortOptions.count
        } else {
            let filter = filterOptions[section - 1]
            return filter.values.first?.count ?? 0
        }
    }

    func option(at indexPath: IndexPath) -> String {
        if indexPath.section == 0 {
            return sortOptions[indexPath.row]
        } else {
            let filter = filterOptions[indexPath.section - 1]
            let filterValues = filter.values.first!
            return filterValues[indexPath.row]
        }
    }

    func isSelected(at indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return sortOptions[indexPath.row] == selectedSortOption
        } else {
            let filter = filterOptions[indexPath.section - 1]
            let filterKey = filter.keys.first!
            let filterValues = filter[filterKey]!
            return selectedFilter[filterKey]?.contains(filterValues[indexPath.row]) ?? false
        }
    }

    func selectOption(at indexPath: IndexPath) {
        if indexPath.section == 0 {
            selectedSortOption = sortOptions[indexPath.row]
        } else {
            let filter = filterOptions[indexPath.section - 1]
            let filterKey = filter.keys.first!
            let filterValues = filter[filterKey]!
            
            var selectedValues = selectedFilter[filterKey] ?? []
            let selectedValue = filterValues[indexPath.row]
            
            if let index = selectedValues.firstIndex(of: selectedValue) {
                selectedValues.remove(at: index)
            } else {
                selectedValues.append(selectedValue)
            }
            
            selectedFilter[filterKey] = selectedValues
        }
    }
}
