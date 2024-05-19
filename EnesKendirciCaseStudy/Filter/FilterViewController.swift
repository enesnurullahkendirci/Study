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
    
    private var headerViewHeight: CGFloat = 44
    private var cellHeight: CGFloat = 35
    private var applyButtonHeight: CGFloat = 44
    
    private lazy var sortTableView: UITableView = {
        let tableView = tableViewCreate()
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.register(SortByTableViewCell.self, forCellReuseIdentifier: SortByTableViewCell.reuseIdentifier)
        tableView.register(FilterSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: FilterSectionHeaderView.reuseIdentifier)
        return tableView
    }()
    
    private lazy var seperatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hex: "#000000").withAlphaComponent(0.5)
        return view
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

    private func tableViewCreate() -> UITableView {
        let tempTableView = UITableView(frame: .zero, style: .grouped)
        tempTableView.translatesAutoresizingMaskIntoConstraints = false
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.separatorStyle = .none
        tempTableView.bounces = false
        tempTableView.alwaysBounceVertical = false
        tempTableView.backgroundColor = .white
        tempTableView.register(FilterOptionTableViewCell.self, forCellReuseIdentifier: FilterOptionTableViewCell.reuseIdentifier)
        tempTableView.register(FilterSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: FilterSectionHeaderView.reuseIdentifier)
        return tempTableView
    }

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
        title = "Filter"
        
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
        
        view.addSubview(headerView)
        view.addSubview(sortTableView)
        view.addSubview(seperatorView)
        view.addSubview(stackView)
        view.addSubview(applyButton)
        
        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            closeButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: headerViewHeight),
            
            sortTableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 15),
            sortTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            sortTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 22),
            sortTableView.heightAnchor.constraint(equalToConstant: cellHeight * CGFloat(viewModel.sortOptions.count + 1)),
            
            seperatorView.topAnchor.constraint(equalTo: sortTableView.bottomAnchor, constant: 15),
            seperatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            seperatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            seperatorView.heightAnchor.constraint(equalToConstant: 1),
            
            stackView.topAnchor.constraint(equalTo: seperatorView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            applyButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            applyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            applyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            applyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            applyButton.heightAnchor.constraint(equalToConstant: applyButtonHeight)
        ])
    }

    private func setupDynamicTableViews() {
        for _ in viewModel.filterOptions {
            let seperatorView = UIView()
            seperatorView.backgroundColor = UIColor(hex: "#000000").withAlphaComponent(0.5)
            seperatorView.translatesAutoresizingMaskIntoConstraints = false
            let tableView = tableViewCreate()
            dynamicTableViews.append(tableView)
            stackView.addArrangedSubview(tableView)
        }
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
        cellHeight
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
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
        
    }
}
