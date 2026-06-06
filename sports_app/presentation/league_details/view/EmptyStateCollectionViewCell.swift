//
//  EmptyStateCollectionViewCell.swift
//  sports_app
//
//  Created by Thaowpsta Saiid on 01/06/2026.
//

import UIKit

class EmptyStateCollectionViewCell: UICollectionViewCell {
    
    let iconImageView = UIImageView()
    let messageLabel = UILabel()
    let containerStack = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        // Card-style container that adapts to light/dark
        contentView.backgroundColor = .secondarySystemGroupedBackground
        contentView.layer.cornerRadius = 14
        contentView.layer.masksToBounds = true
        
        // Icon
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .tertiaryLabel
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconImageView.heightAnchor.constraint(equalToConstant: 36),
            iconImageView.widthAnchor.constraint(equalToConstant: 36)
        ])
        
        // Message
        messageLabel.textAlignment = .center
        messageLabel.textColor = .secondaryLabel
        messageLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        messageLabel.numberOfLines = 0
        
        // Stack
        containerStack.axis = .vertical
        containerStack.alignment = .center
        containerStack.spacing = 10
        containerStack.translatesAutoresizingMaskIntoConstraints = false
        
        containerStack.addArrangedSubview(iconImageView)
        containerStack.addArrangedSubview(messageLabel)
        
        contentView.addSubview(containerStack)
        
        NSLayoutConstraint.activate([
            containerStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            containerStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            containerStack.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 16),
            containerStack.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    func configure(message: String, systemImageName: String) {
        messageLabel.text = message
        iconImageView.image = UIImage(systemName: systemImageName)
        
        // Re-apply adaptive colors so it works in both light and dark mode
        contentView.backgroundColor = .secondarySystemGroupedBackground
        iconImageView.tintColor = .tertiaryLabel
        messageLabel.textColor = .secondaryLabel
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        // Update colors when switching between light/dark mode
        contentView.backgroundColor = .secondarySystemGroupedBackground
        iconImageView.tintColor = .tertiaryLabel
        messageLabel.textColor = .secondaryLabel
    }
}
