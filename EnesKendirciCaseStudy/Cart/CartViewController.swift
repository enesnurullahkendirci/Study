//
//  CartViewController.swift
//  EnesKendirciCaseStudy
//
//  Created by Enes KENDİRCİ on 17.05.2024.
//

import UIKit

final class CartViewController: BaseViewController {
    private var viewModel = CartViewModel()
    
    private let tableView = UITableView()
    private let totalPriceLabel = UILabel()
    private let completeButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.loadCartItems()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CartTableViewCell.self, forCellReuseIdentifier: CartTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        
        totalPriceLabel.font = UIFont.boldSystemFont(ofSize: 24)
        totalPriceLabel.textColor = .black
        view.addSubview(totalPriceLabel)
        
        completeButton.setTitle("Complete", for: .normal)
        completeButton.backgroundColor = .blue
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        view.addSubview(completeButton)
        
        // Layout constraints
        tableView.translatesAutoresizingMaskIntoConstraints = false
        totalPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 17),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            tableView.bottomAnchor.constraint(equalTo: totalPriceLabel.topAnchor, constant: -10),
            
            totalPriceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            totalPriceLabel.bottomAnchor.constraint(equalTo: completeButton.topAnchor, constant: -10),
            
            completeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            completeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            completeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            completeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func bindViewModel() {
        viewModel.listenCartItems()
        viewModel.onCartItemsChanged = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.totalPriceLabel.text = "Total: \(self?.viewModel.totalPrice ?? "0₺")"
                self?.tabBarItem.badgeValue = self?.viewModel.cartItems.isEmpty == true ? nil : "\(self?.viewModel.cartItems.count)"
            }
        }
    }
    
    @objc private func completeButtonTapped() {
        viewModel.completePurchase()
    }
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.reuseIdentifier, for: indexPath) as? CartTableViewCell else {
            return UITableViewCell()
        }
        
        let cartItem = viewModel.cartItems[indexPath.row]
        guard let quantity = cartItem.quantity else { return cell }
        cell.configure(with: cartItem, quantity: quantity, increaseAction: { [weak self] in
            self?.viewModel.increaseQuantity(of: cartItem)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }, decreaseAction: { [weak self] in
            self?.viewModel.decreaseQuantity(of: cartItem)
            tableView.reloadData()
        })
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = viewModel.cartItems[indexPath.row]
        let productDetailViewController = ProductDetailViewController(product: product)
        navigationController?.pushViewController(productDetailViewController, animated: true)
    }
}
