//
//  ProductDetailViewController.swift
//  EnesKendirciCaseStudy
//
//  Created by Enes KENDİRCİ on 20.05.2024.
//

import UIKit

final class ProductDetailViewController: BaseViewController {
    
    let viewModel = ProductDetailViewModel()
    var product: Product
    
    init(product: Product) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let productDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Price:"
        label.textColor = UIColor(hex: "#2A59FE")
        return label
    }()
    
    private let productPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addToCartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add to Cart", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = UIColor(hex: "#2A59FE")
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(didTapAddToCartButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = product.name
        setupUI()
        configureUI()
    }
    
    private func setupUI() {
        view.addSubview(productImageView)
        view.addSubview(productNameLabel)
        view.addSubview(productDescriptionTextView)
        view.addSubview(priceStackView)
        view.addSubview(addToCartButton)
        
        priceStackView.addArrangedSubview(priceLabel)
        priceStackView.addArrangedSubview(productPriceLabel)
        
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            productImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            productImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            productImageView.heightAnchor.constraint(equalToConstant: 225),
            
            productNameLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 16),
            productNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            productNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            productDescriptionTextView.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 16),
            productDescriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            productDescriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            priceStackView.topAnchor.constraint(equalTo: productDescriptionTextView.bottomAnchor, constant: 16),
            priceStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            priceStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            addToCartButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addToCartButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addToCartButton.heightAnchor.constraint(equalToConstant: 38),
            addToCartButton.widthAnchor.constraint(equalToConstant: 182),
            addToCartButton.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    @objc private func didTapAddToCartButton() {
        viewModel.addToCart(product: product)
    }
    
    private func configureUI() {
        productNameLabel.text = product.name
        productDescriptionTextView.text = product.description
        if let price = product.price {
            productPriceLabel.text = "\(price) ₺"
        }
        
        // Asynchronous image loading
        if let imageUrl = product.image, let url = URL(string: imageUrl) {
            NetworkManager.shared.loadImage(from: url) { image in
                DispatchQueue.main.async { [weak self] in
                    self?.productImageView.image = image
                }
            }
        }
    }
}
