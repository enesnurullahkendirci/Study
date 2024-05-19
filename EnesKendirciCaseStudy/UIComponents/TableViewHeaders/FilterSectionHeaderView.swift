//
//  FilterSectionHeaderView.swift
//  EnesKendirciCaseStudy
//
//  Created by Enes KENDİRCİ on 19.05.2024.
//

import UIKit

final class FilterSectionHeaderView: UITableViewHeaderFooterView {

    static let reuseIdentifier = "FilterSectionHeaderView"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()

    private let searchBar: CustomSearchBar = {
        let searchBar = CustomSearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hex: "#808080")
        return view
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        contentView.backgroundColor = .white
        contentView.addSubview(containerView)
        containerView.addSubview(separatorView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            separatorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            separatorView.bottomAnchor.constraint(equalTo: containerView.topAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: separatorView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: separatorView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: separatorView.trailingAnchor, constant: -16),
        ])
    }
    
    func configure(title: String, searchBarDelegate: UISearchBarDelegate?, shouldShowSearchBar: Bool) {
        titleLabel.text = title
        if shouldShowSearchBar {
            contentView.addSubview(searchBar)
            NSLayoutConstraint.activate([
                searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
                searchBar.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
                searchBar.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
                searchBar.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),
            ])
        } else {
            searchBar.removeFromSuperview()
            NSLayoutConstraint.activate([
                titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),
            ])
        }
        
        
        guard let searchBarDelegate else { return }
        searchBar.setDelegate(searchBarDelegate)
    }
}
