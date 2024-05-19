//
//  FilterViewController.swift
//  EnesKendirciCaseStudy
//
//  Created by Enes KENDİRCİ on 19.05.2024.
//

import UIKit

protocol FilterViewControllerDelegate: AnyObject {
    func didApplyFilters(selectedFilters: [String: [String]], selectedSortOptions: String?)
}

final class FilterViewController: UIViewController {

    weak var delegate: FilterViewControllerDelegate?
    private var viewModel: FilterViewModel
    
    private let headerViewHeight: CGFloat = 44
    private let cellHeight: CGFloat = 35
    private let applyButtonHeight: CGFloat = 44
    
    private lazy var sortTableView: UITableView = {
        return createTableView()
    }()
    
    private lazy var separatorView: UIView = {
        return createSeparatorView()
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 1
        stackView.backgroundColor = UIColor(hex: "#000000").withAlphaComponent(0.5)
        return stackView
    }()
    
    private lazy var applyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Primary", for: .normal)
        button.backgroundColor = UIColor(hex: "#2A59FE")
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(didTapApplyButton), for: .touchUpInside)
        return button
    }()
    
    private var dynamicTableViews: [UITableView] = []
    
    init(filterOptions: [[String: [String]]], sortOptions: [String]) {
        self.viewModel = FilterViewModel(filterOptions: filterOptions, sortOptions: sortOptions)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupDynamicTableViews()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        let headerView = createHeaderView()
        view.addSubview(headerView)
        view.addSubview(sortTableView)
        view.addSubview(separatorView)
        view.addSubview(stackView)
        view.addSubview(applyButton)
        
        setupConstraints(headerView: headerView)
    }
    
    private func setupDynamicTableViews() {
        for _ in viewModel.filterOptions {
            let separatorView = createSeparatorView()
            let tableView = createTableView()
            dynamicTableViews.append(tableView)
            stackView.addArrangedSubview(tableView)
        }
    }
    
    private func createHeaderView() -> UIView {
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = "Filter"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(closeButton)
        headerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            closeButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        return headerView
    }
    
    private func createSeparatorView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hex: "#000000").withAlphaComponent(0.5)
        return view
    }
    
    private func createTableView() -> UITableView {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.alwaysBounceVertical = false
        tableView.backgroundColor = .white
        tableView.register(FilterOptionTableViewCell.self, forCellReuseIdentifier: FilterOptionTableViewCell.reuseIdentifier)
        tableView.register(SortByTableViewCell.self, forCellReuseIdentifier: SortByTableViewCell.reuseIdentifier)
        tableView.register(FilterSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: FilterSectionHeaderView.reuseIdentifier)
        return tableView
    }
    
    private func setupConstraints(headerView: UIView) {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: headerViewHeight),
            
            sortTableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 15),
            sortTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            sortTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 22),
            sortTableView.heightAnchor.constraint(equalToConstant: cellHeight * CGFloat(viewModel.sortOptions.count + 1)),
            
            separatorView.topAnchor.constraint(equalTo: sortTableView.bottomAnchor, constant: 15),
            separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            stackView.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            applyButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            applyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            applyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            applyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            applyButton.heightAnchor.constraint(equalToConstant: applyButtonHeight)
        ])
    }
    
    @objc private func didTapCloseButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapApplyButton() {
        delegate?.didApplyFilters(selectedFilters: viewModel.selectedFilter, selectedSortOptions: viewModel.selectedSortOption)
        dismiss(animated: true, completion: nil)
    }
}

extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == sortTableView {
            return viewModel.numberOfRows(in: 0)
        } else if let index = dynamicTableViews.firstIndex(of: tableView) {
            return viewModel.numberOfRows(in: index + 1)
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == sortTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SortByTableViewCell.reuseIdentifier, for: indexPath) as? SortByTableViewCell else {
                return UITableViewCell()
            }
            let option = viewModel.option(at: indexPath)
            let isSelected = viewModel.isSelected(at: indexPath)
            cell.configure(with: option, isSelected: isSelected)
            return cell
        } else if let index = dynamicTableViews.firstIndex(of: tableView) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FilterOptionTableViewCell.reuseIdentifier, for: indexPath) as? FilterOptionTableViewCell else {
                return UITableViewCell()
            }
            let adjustedIndexPath = IndexPath(row: indexPath.row, section: index + 1)
            let option = viewModel.option(at: adjustedIndexPath)
            let isSelected = viewModel.isSelected(at: adjustedIndexPath)
            cell.configure(with: option, isSelected: isSelected)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == sortTableView {
            viewModel.selectOption(at: indexPath)
            tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
        } else if let index = dynamicTableViews.firstIndex(of: tableView) {
            let adjustedIndexPath = IndexPath(row: indexPath.row, section: index + 1)
            viewModel.selectOption(at: adjustedIndexPath)
            tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
        }
        
        guard let searchBar = (tableView.headerView(forSection: .zero) as? FilterSectionHeaderView)?.searchBar.searchBar else { return }
        self.searchBar(searchBar, textDidChange: "")
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: FilterSectionHeaderView.reuseIdentifier) as? FilterSectionHeaderView else {
            return nil
        }
        let title: String
        let shouldShowSearchBar: Bool
        if tableView == sortTableView {
            title = "Sort By"
            shouldShowSearchBar = false
        } else if let index = dynamicTableViews.firstIndex(of: tableView) {
            title = viewModel.filterOptions[index].keys.first ?? ""
            shouldShowSearchBar = true
        } else {
            return nil
        }
        headerView.configure(title: title, searchBarDelegate: self, shouldShowSearchBar: shouldShowSearchBar)
        return headerView
    }
}

extension FilterViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        for (index, tableView) in dynamicTableViews.enumerated() {
            if let headerView = tableView.headerView(forSection: 0) as? FilterSectionHeaderView,
               headerView.contains(searchBar: searchBar) {
                viewModel.searchFilter(for: searchText, in: index + 1)
                tableView.reloadData()
                break
            }
        }
    }
}
