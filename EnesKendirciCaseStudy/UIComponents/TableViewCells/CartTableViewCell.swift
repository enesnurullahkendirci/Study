//
//  CartTableViewCell.swift
//  EnesKendirciCaseStudy
//
//  Created by Enes KENDİRCİ on 20.05.2024.
//

import UIKit

final class CartTableViewCell: BaseTableViewCell {
    
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let quantityLabel = UILabel()
    private let increaseButton = UIButton()
    private let decreaseButton = UIButton()

    private var increaseAction: (() -> Void)?
    private var decreaseAction: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with product: Product, quantity: Int, increaseAction: @escaping () -> Void, decreaseAction: @escaping () -> Void) {
        nameLabel.text = product.name
        priceLabel.text = product.price
        quantityLabel.text = "\(quantity)"
        self.increaseAction = increaseAction
        self.decreaseAction = decreaseAction
    }

    private func setupUI() {
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        priceLabel.font = UIFont.systemFont(ofSize: 13)
        priceLabel.textColor = UIColor(hex: "#2A59FE")
        
        quantityLabel.font = UIFont.systemFont(ofSize: 18)
        quantityLabel.backgroundColor = UIColor(hex: "#2A59FE")
        quantityLabel.textColor = .white
        quantityLabel.textAlignment = .center
        quantityLabel.layer.masksToBounds = true

        increaseButton.setTitle("+", for: .normal)
        increaseButton.backgroundColor = UIColor(hex: "#F4F4F6")
        increaseButton.setTitleColor(.black, for: .normal)
        increaseButton.layer.cornerRadius = 4
        increaseButton.layer.masksToBounds = true
        increaseButton.addTarget(self, action: #selector(increaseButtonTapped), for: .touchUpInside)

        decreaseButton.setTitle("-", for: .normal)
        decreaseButton.backgroundColor = UIColor(hex: "#F4F4F6")
        decreaseButton.setTitleColor(.black, for: .normal)
        decreaseButton.layer.cornerRadius = 4
        decreaseButton.layer.masksToBounds = true
        decreaseButton.addTarget(self, action: #selector(decreaseButtonTapped), for: .touchUpInside)

        let buttonSize: CGFloat = 42 // Butonların genişlik ve yükseklik değeri

        quantityLabel.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        quantityLabel.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        increaseButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        increaseButton.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        decreaseButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        decreaseButton.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true

        let stackView = UIStackView(arrangedSubviews: [decreaseButton, quantityLabel, increaseButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally // Butonların eşit genişlikte olmasını sağlar

        let labelsStackView = UIStackView(arrangedSubviews: [nameLabel, priceLabel])
        labelsStackView.axis = .vertical

        let mainStackView = UIStackView(arrangedSubviews: [labelsStackView, stackView])
        mainStackView.axis = .horizontal
        mainStackView.alignment = .center // Butonlar ve etiketlerin aynı hizaya gelmesini sağlar
        mainStackView.spacing = 16

        contentView.addSubview(mainStackView)

        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    @objc private func increaseButtonTapped() {
        increaseAction?()
    }

    @objc private func decreaseButtonTapped() {
        decreaseAction?()
    }
}
