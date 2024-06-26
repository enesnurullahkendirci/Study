//
//  ProductCollectionViewCell.swift
//  EnesKendirciCaseStudy
//
//  Created by Enes KENDİRCİ on 18.05.2024.
//

import UIKit

final class ProductCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "ProductCollectionViewCell"
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.tintColor = .yellow
        return button
    }()
    
    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let productPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    private let addToCartButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add to Cart", for: .normal)
        button.backgroundColor = UIColor(hex: "#2A59FE")
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private var product: Product?
    var onFavoriteButtonTapped: ((Product?) -> Void)?
    var onAddToCartButtonTapped: ((Product?) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupActions()
    }
    
    private func setupView() {
        contentView.addSubview(productImageView)
        contentView.addSubview(favoriteButton)
        contentView.addSubview(productNameLabel)
        contentView.addSubview(productPriceLabel)
        contentView.addSubview(addToCartButton)
        
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            productImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.75),
            
            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            productNameLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 8),
            productNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            productNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            productPriceLabel.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 4),
            productPriceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            productPriceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            addToCartButton.topAnchor.constraint(equalTo: productPriceLabel.bottomAnchor, constant: 8),
            addToCartButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            addToCartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            addToCartButton.heightAnchor.constraint(equalToConstant: 40),
            addToCartButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    private func setupActions() {
        addToCartButton.addTarget(self, action: #selector(didTapAddToCartButton), for: .touchUpInside)
        favoriteButton.addTarget(self, action: #selector(didTapFavoriteButton), for: .touchUpInside)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        productImageView.image = nil
        onFavoriteButtonTapped = nil
        onAddToCartButtonTapped = nil
        product = nil
    }
    
    func configure(with product: Product, isFavorite: Bool) {
        self.product = product
        productNameLabel.text = product.name
        guard let price = product.price else { return }
        productPriceLabel.text = "\(price) ₺"
        favoriteButton.setImage(
            UIImage(resource: isFavorite ? .iconStarFill : .iconStarEmpty),
            for: .normal)
        
        guard let imageURLString = product.image, let imageURL = URL(string: imageURLString) else { return }
        
        NetworkManager.shared.loadImage(from: imageURL) { [weak self] image in
            DispatchQueue.main.async {
                self?.productImageView.image = image
            }
        }
    }
    
    @objc private func didTapAddToCartButton() {
        onAddToCartButtonTapped?(product)
    }
    
    @objc private func didTapFavoriteButton() {
        onFavoriteButtonTapped?(product)
    }
}
