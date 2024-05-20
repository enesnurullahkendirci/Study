//
//  FilterOptionTableViewCell.swift
//  EnesKendirciCaseStudy
//
//  Created by Enes KENDİRCİ on 19.05.2024.
//

import UIKit

class FilterOptionTableViewCell: BaseTableViewCell {

    static let reuseIdentifier = "FilterOptionTableViewCell"

    private let optionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private let optionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(hex: "#2A59FE")
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        contentView.addSubview(optionLabel)
        contentView.addSubview(optionImageView)
        
        NSLayoutConstraint.activate([
            optionImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            optionImageView.centerYAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            optionImageView.widthAnchor.constraint(equalToConstant: 16),
            optionImageView.heightAnchor.constraint(equalToConstant: 16),
            
            optionLabel.leadingAnchor.constraint(equalTo: optionImageView.trailingAnchor, constant: 16),
            optionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            optionLabel.centerYAnchor.constraint(equalTo: contentView.topAnchor, constant: 15)
        ])
    }

    func configure(with option: String, isSelected: Bool) {
        optionLabel.text = option
        optionImageView.image = isSelected ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "circle")
    }
}
