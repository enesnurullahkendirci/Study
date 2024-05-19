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
    var sortOptions: [String]
    var searchResults: [[String: [String]]]
    
    init(filterOptions: [[String: [String]]], sortOptions: [String]) {
        self.filterOptions = filterOptions
        self.sortOptions = sortOptions
        self.searchResults = filterOptions
    }

    func numberOfRows(in section: Int) -> Int {
        if section == 0 {
            return sortOptions.count
        } else {
            return searchResults[section - 1].values.first?.count ?? 0
        }
    }

    func option(at indexPath: IndexPath) -> String {
        if indexPath.section == 0 {
            return sortOptions[indexPath.row]
        } else {
            return searchResults[indexPath.section - 1].values.first?[indexPath.row] ?? ""
        }
    }

    func isSelected(at indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return sortOptions[indexPath.row] == selectedSortOption
        } else {
            let filter = searchResults[indexPath.section - 1]
            let filterKey = filter.keys.first!
            let filterValues = filter[filterKey]!
            return selectedFilter[filterKey]?.contains(filterValues[indexPath.row]) ?? false
        }
    }

    func selectOption(at indexPath: IndexPath) {
        if indexPath.section == 0 {
            selectedSortOption = sortOptions[indexPath.row]
        } else {
            let filter = searchResults[indexPath.section - 1]
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

    func searchFilter(for text: String, in section: Int) {
        if text.isEmpty {
            searchResults = filterOptions
        } else {
            searchResults = filterOptions.map { filter in
                var newFilter = filter
                let key = filter.keys.first!
                newFilter[key] = filter[key]?.filter { $0.lowercased().contains(text.lowercased()) }
                return newFilter
            }
        }
    }
}
