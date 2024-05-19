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
    private(set) var selectedBrands: [String] = []
    private(set) var selectedModels: [String] = []
    
    let sortOptions = ["Old to new", "New to old", "Price high to low", "Price low to high"]

    init(filterOptions: [[String: [String]]]) {
        self.filterOptions = filterOptions
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
            let filterKey = filter.keys.first
            let filterValues = filter[filterKey!]!
            if filterKey == "Brand" {
                return selectedBrands.contains(filterValues[indexPath.row])
            } else if filterKey == "Model" {
                return selectedModels.contains(filterValues[indexPath.row])
            }
            return false
        }
    }

    func selectOption(at indexPath: IndexPath) {
        if indexPath.section == 0 {
            selectedSortOption = sortOptions[indexPath.row]
        } else {
            let filter = filterOptions[indexPath.section - 1]
            let filterKey = filter.keys.first
            let filterValues = filter[filterKey!]!
            
            if filterKey == "Brand" {
                let selectedBrand = filterValues[indexPath.row]
                if selectedBrands.contains(selectedBrand) {
                    selectedBrands.removeAll { $0 == selectedBrand }
                } else {
                    selectedBrands.append(selectedBrand)
                }
            } else if filterKey == "Model" {
                let selectedModel = filterValues[indexPath.row]
                if selectedModels.contains(selectedModel) {
                    selectedModels.removeAll { $0 == selectedModel }
                } else {
                    selectedModels.append(selectedModel)
                }
            }
        }
    }
}
