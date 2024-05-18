//
//  ProductListViewController.swift
//  EnesKendirciCaseStudy
//
//  Created by Enes KENDİRCİ on 17.05.2024.
//

import UIKit

final class ProductListViewController: BaseViewController {
    private lazy var customSearchBar: CustomSearchBar = {
        let searchBar = CustomSearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private lazy var filterView: UIView = {
        let filterView = UIView()
        filterView.translatesAutoresizingMaskIntoConstraints = false
        return filterView
    }()
    
    private lazy var filterLabel: UILabel = {
        let filterLabel = UILabel()
        filterLabel.translatesAutoresizingMaskIntoConstraints = false
        filterLabel.text = "Filters:"
        return filterLabel
    }()
    
    private lazy var filterButton: UIButton = {
        let filterButton = UIButton()
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        filterButton.setTitle("Select Filter", for: .normal)
        filterButton.setTitleColor(.black, for: .normal)
        filterButton.backgroundColor = UIColor(hex: "#D9D9D9")
        return filterButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupFilterView()
    }
    
    private func setupSearchBar() {
        view.addSubview(customSearchBar)
        NSLayoutConstraint.activate([
            customSearchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 14),
            customSearchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            customSearchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            customSearchBar.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        customSearchBar.setDelegate(self)
    }
    
    private func setupFilterView() {
        view.addSubview(filterView)
        filterView.addSubview(filterLabel)
        filterView.addSubview(filterButton)
        
        NSLayoutConstraint.activate([
            filterView.topAnchor.constraint(equalTo: customSearchBar.bottomAnchor, constant: 14),
            filterView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filterView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            filterView.heightAnchor.constraint(equalToConstant: 40),
            
            filterLabel.leadingAnchor.constraint(equalTo: filterView.leadingAnchor),
            filterLabel.centerYAnchor.constraint(equalTo: filterView.centerYAnchor),
            
            filterButton.trailingAnchor.constraint(equalTo: filterView.trailingAnchor),
            filterButton.topAnchor.constraint(equalTo: filterView.topAnchor),
            filterButton.bottomAnchor.constraint(equalTo: filterView.bottomAnchor),
            filterButton.widthAnchor.constraint(equalToConstant: 158),
        ])
    }
}

extension ProductListViewController: UISearchBarDelegate {

}
