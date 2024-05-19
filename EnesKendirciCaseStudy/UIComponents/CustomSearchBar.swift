//
//  CustomSearchBar.swift
//  EnesKendirciCaseStudy
//
//  Created by Enes KENDİRCİ on 18.05.2024.
//

import UIKit

final class CustomSearchBar: UIView {

    private(set) lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
        searchBar.setImage(UIImage(systemName: "magnifyingglass"), for: .search, state: .normal)
        return searchBar
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func setDelegate(_ delegate: UISearchBarDelegate) {
        searchBar.delegate = delegate
    }
}
