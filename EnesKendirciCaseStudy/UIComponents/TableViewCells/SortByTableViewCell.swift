//
//  SortByTableViewCell.swift
//  EnesKendirciCaseStudy
//
//  Created by Enes KENDİRCİ on 19.05.2024.
//

import UIKit

class SortByTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "SortByTableViewCell"
    
    private let sortOptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private let sortOptionImageView: UIImageView = {
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
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        contentView.addSubview(sortOptionLabel)
        contentView.addSubview(sortOptionImageView)
        
        NSLayoutConstraint.activate([
            sortOptionImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            sortOptionImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            sortOptionImageView.widthAnchor.constraint(equalToConstant: 24),
            sortOptionImageView.heightAnchor.constraint(equalToConstant: 24),
            
            sortOptionLabel.leadingAnchor.constraint(equalTo: sortOptionImageView.trailingAnchor, constant: 16),
            sortOptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            sortOptionLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(with option: String, isSelected: Bool) {
        sortOptionLabel.text = option
        sortOptionImageView.image = isSelected ? UIImage(systemName: "circle.inset.filled") : UIImage(systemName: "circle")
    }
}
