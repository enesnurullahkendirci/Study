//
//  FilterViewController.swift
//  EnesKendirciCaseStudy
//
//  Created by Enes KENDİRCİ on 19.05.2024.
//

import UIKit

final class FilterViewController: UIViewController {

    private var viewModel: FilterViewModel

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.register(SortByTableViewCell.self, forCellReuseIdentifier: SortByTableViewCell.reuseIdentifier)
        tableView.register(FilterOptionTableViewCell.self, forCellReuseIdentifier: FilterOptionTableViewCell.reuseIdentifier)
        tableView.register(FilterSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: FilterSectionHeaderView.reuseIdentifier)
        return tableView
    }()

    init(filterOptions: [[String: [String]]]) {
        self.viewModel = FilterViewModel(filterOptions: filterOptions)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
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
        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            closeButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let applyButton = UIButton(type: .system)
        applyButton.setTitle("Apply", for: .normal)
        applyButton.backgroundColor = UIColor(hex: "#2A59FE")
        applyButton.setTitleColor(.white, for: .normal)
        applyButton.translatesAutoresizingMaskIntoConstraints = false
        applyButton.addTarget(self, action: #selector(didTapApplyButton), for: .touchUpInside)
        
        view.addSubview(applyButton)
        NSLayoutConstraint.activate([
            applyButton.heightAnchor.constraint(equalToConstant: 50),
            applyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            applyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            applyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }

    @objc private func didTapCloseButton() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func didTapApplyButton() {
        // Filtrelerin uygulanması işlemleri burada yapılacak
        dismiss(animated: true, completion: nil)
    }
}

extension FilterViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        nil
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SortByTableViewCell.reuseIdentifier, for: indexPath) as? SortByTableViewCell else {
                return UITableViewCell()
            }
            let option = viewModel.option(at: indexPath)
            let isSelected = viewModel.isSelected(at: indexPath)
            cell.configure(with: option, isSelected: isSelected)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FilterOptionTableViewCell.reuseIdentifier, for: indexPath) as? FilterOptionTableViewCell else {
                return UITableViewCell()
            }
            let option = viewModel.option(at: indexPath)
            let isSelected = viewModel.isSelected(at: indexPath)
            cell.configure(with: option, isSelected: isSelected)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectOption(at: indexPath)
        tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: FilterSectionHeaderView.reuseIdentifier) as? FilterSectionHeaderView else {
            return nil
        }
        let title = viewModel.titleForHeader(in: section)
        let shouldShowSearchBar = (section != 0)
        headerView.configure(title: title ?? "", searchBarDelegate: shouldShowSearchBar ? self : nil, shouldShowSearchBar: shouldShowSearchBar)
        return headerView
    }
}

extension FilterViewController: UISearchBarDelegate {
    
}
