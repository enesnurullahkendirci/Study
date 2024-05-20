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
        filterButton.addTarget(self, action: #selector(didTapFilterButton), for: .touchUpInside)
        return filterButton
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        layout.itemSize = CGSize(width: (view.frame.width - 48) / 2, height: 250)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: ProductCollectionViewCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    private var viewModel = ProductListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupFilterView()
        setupCollectionView()
        
        fetchProducts()
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
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: filterView.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func fetchProducts() {
        viewModel.fetchProducts { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    @objc private func didTapFilterButton() {
        let filterOptions = viewModel.getFilterOptions()
        let filterViewController = FilterViewController(filterOptions: filterOptions, sortOptions: viewModel.sortOptionCases)
        filterViewController.delegate = self
        filterViewController.modalPresentationStyle = .automatic
        present(filterViewController, animated: true, completion: nil)
    }
}

extension ProductListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.reuseIdentifier, for: indexPath) as? ProductCollectionViewCell else {
            return UICollectionViewCell()
        }
        let product = viewModel.product(at: indexPath.row)
        cell.configure(with: product)
        cell.onAddToCartButtonTapped = { [weak self] product in
            guard let product else { return }
            
            self?.viewModel.addToCart(product: product)
        }
        cell.onFavoriteButtonTapped = { [weak self] product in
            guard let product else { return }
            
//            self?.viewModel.toggleFavorite(product: product)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: - Implement product detail navigation
    }
}

extension ProductListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterProducts(by: searchText) { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}

extension ProductListViewController: FilterViewControllerDelegate {
    func didApplyFilters(selectedFilters: [String : [String]], selectedSortOptions: String?) {
        viewModel.applyFilters(selectedFilters: selectedFilters, selectedSortOption: selectedSortOptions) { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}
