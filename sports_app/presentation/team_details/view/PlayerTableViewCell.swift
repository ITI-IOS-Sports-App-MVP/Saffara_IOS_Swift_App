//
//  PlayerTableViewCell.swift
//  sports_app
//

import UIKit
import Kingfisher

class PlayerTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "PlayerTableViewCell"
    
    // UI Elements
    private let cardContainer = UIView()
    private let playerImageView = UIImageView()
    private let nameLabel = UILabel()
    private let detailsLabel = UILabel()
    private let numberBadgeContainer = UIView()
    private let numberBadgeLabel = UILabel()
    private let separatorView = UIView()
    
    // Stats Rows
    private let ratingRow = UIStackView()
    private let ratingTitleLabel = UILabel()
    private let ratingValueLabel = UILabel()
    
    private let yellowCardRow = UIStackView()
    private let yellowCardTitleLabel = UILabel()
    private let yellowCardValueLabel = UILabel()
    
    private let redCardRow = UIStackView()
    private let redCardTitleLabel = UILabel()
    private let redCardValueLabel = UILabel()
    
    private let statsStackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    private func setupCell() {
        backgroundColor = .clear
        selectionStyle = .none
        
        // Card Container Setup
        cardContainer.backgroundColor = .secondarySystemGroupedBackground
        cardContainer.layer.cornerRadius = 14
        cardContainer.layer.shadowColor = UIColor.black.cgColor
        cardContainer.layer.shadowOpacity = 0.03
        cardContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardContainer.layer.shadowRadius = 4
        cardContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardContainer)
        
        // Player Profile Image
        playerImageView.contentMode = .scaleAspectFill
        playerImageView.clipsToBounds = true
        playerImageView.backgroundColor = .systemGray5
        playerImageView.layer.cornerRadius = 25
        playerImageView.translatesAutoresizingMaskIntoConstraints = false
        cardContainer.addSubview(playerImageView)
        
        // Name Label
        nameLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        nameLabel.textColor = .label
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        cardContainer.addSubview(nameLabel)
        
        // Details Label (Position & Age)
        detailsLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        detailsLabel.textColor = .secondaryLabel
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        cardContainer.addSubview(detailsLabel)
        
        // Number Badge Label & Container
        numberBadgeContainer.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.12)
        numberBadgeContainer.layer.cornerRadius = 8
        numberBadgeContainer.translatesAutoresizingMaskIntoConstraints = false
        cardContainer.addSubview(numberBadgeContainer)
        
        numberBadgeLabel.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        numberBadgeLabel.textColor = .systemBlue
        numberBadgeLabel.textAlignment = .center
        numberBadgeLabel.translatesAutoresizingMaskIntoConstraints = false
        numberBadgeContainer.addSubview(numberBadgeLabel)
        
        // Separator Line
        separatorView.backgroundColor = .separator
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        cardContainer.addSubview(separatorView)
        
        // Stats Stack View Setup
        statsStackView.axis = .vertical
        statsStackView.spacing = 8
        statsStackView.distribution = .fillEqually
        statsStackView.translatesAutoresizingMaskIntoConstraints = false
        cardContainer.addSubview(statsStackView)
        
        // Configure individual stats rows
        setupStatsRow(row: ratingRow, titleLabel: ratingTitleLabel, valueLabel: ratingValueLabel, title: "Rating", valueColor: .systemGreen)
        setupStatsRow(row: yellowCardRow, titleLabel: yellowCardTitleLabel, valueLabel: yellowCardValueLabel, title: "Yellow cards", valueColor: .systemOrange)
        setupStatsRow(row: redCardRow, titleLabel: redCardTitleLabel, valueLabel: redCardValueLabel, title: "Red cards", valueColor: .systemRed)
        
        // Layout constraints
        NSLayoutConstraint.activate([
            // Card Container constraints
            cardContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            // Player Image constraints
            playerImageView.topAnchor.constraint(equalTo: cardContainer.topAnchor, constant: 16),
            playerImageView.leadingAnchor.constraint(equalTo: cardContainer.leadingAnchor, constant: 16),
            playerImageView.widthAnchor.constraint(equalToConstant: 50),
            playerImageView.heightAnchor.constraint(equalToConstant: 50),
            
            // Name Label constraints
            nameLabel.topAnchor.constraint(equalTo: playerImageView.topAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: playerImageView.trailingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: numberBadgeContainer.leadingAnchor, constant: -8),
            
            // Details Label constraints
            detailsLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            detailsLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            detailsLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            // Number Badge constraints
            numberBadgeContainer.topAnchor.constraint(equalTo: cardContainer.topAnchor, constant: 16),
            numberBadgeContainer.trailingAnchor.constraint(equalTo: cardContainer.trailingAnchor, constant: -16),
            numberBadgeContainer.widthAnchor.constraint(equalToConstant: 34),
            numberBadgeContainer.heightAnchor.constraint(equalToConstant: 24),
            
            numberBadgeLabel.centerXAnchor.constraint(equalTo: numberBadgeContainer.centerXAnchor),
            numberBadgeLabel.centerYAnchor.constraint(equalTo: numberBadgeContainer.centerYAnchor),
            
            // Separator constraints
            separatorView.topAnchor.constraint(equalTo: playerImageView.bottomAnchor, constant: 12),
            separatorView.leadingAnchor.constraint(equalTo: cardContainer.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: cardContainer.trailingAnchor, constant: -16),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5),
            
            // Stats Stack constraints
            statsStackView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 12),
            statsStackView.leadingAnchor.constraint(equalTo: cardContainer.leadingAnchor, constant: 16),
            statsStackView.trailingAnchor.constraint(equalTo: cardContainer.trailingAnchor, constant: -16),
            statsStackView.bottomAnchor.constraint(equalTo: cardContainer.bottomAnchor, constant: -16)
        ])
    }
    
    private func setupStatsRow(row: UIStackView, titleLabel: UILabel, valueLabel: UILabel, title: String, valueColor: UIColor) {
        row.axis = .horizontal
        row.distribution = .equalSpacing
        
        titleLabel.text = title
        titleLabel.textColor = .secondaryLabel
        titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        
        valueLabel.textColor = valueColor
        valueLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        
        row.addArrangedSubview(titleLabel)
        row.addArrangedSubview(valueLabel)
        
        statsStackView.addArrangedSubview(row)
    }
    
    func configure(with player: Player) {
        nameLabel.text = player.playerName ?? "Unknown Player"
        
        let position = player.playerType ?? "Player"
        let ageStr = player.playerAge != nil ? "Age \(player.playerAge!)" : ""
        let spacing = (!position.isEmpty && !ageStr.isEmpty) ? " · " : ""
        detailsLabel.text = "\(position)\(spacing)\(ageStr)"
        
        let number = player.playerNumber ?? ""
        numberBadgeLabel.text = number.isEmpty ? "-" : "#\(number)"
        
        // Handle rating, yellow/red cards
        ratingValueLabel.text = player.playerRating?.isEmpty == false ? player.playerRating : "N/A"
        
        let yellowCards = player.playerYellowCards ?? ""
        yellowCardValueLabel.text = yellowCards.isEmpty ? "0" : yellowCards
        
        let redCards = player.playerRedCards ?? ""
        redCardValueLabel.text = redCards.isEmpty ? "0" : redCards
        
        // Setup image view using Kingfisher
        let placeholder = UIImage(systemName: "person.crop.circle.fill")
        if let imageStr = player.playerImage, let url = URL(string: imageStr) {
            playerImageView.kf.setImage(with: url, placeholder: placeholder)
        } else {
            playerImageView.image = placeholder
        }
    }
}
