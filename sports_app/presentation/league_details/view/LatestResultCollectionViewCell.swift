//
//  LatestResultCollectionViewCell.swift
//  sports_app
//
//  Created by Thaowpsta Saiid on 29/05/2026.
//

import UIKit
import Kingfisher

class LatestResultCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
        
        @IBOutlet weak var homeTeamImageView: UIImageView!
        @IBOutlet weak var homeTeamNameLabel: UILabel!
        @IBOutlet weak var homeScoreLabel: UILabel!
        @IBOutlet weak var awayTeamImageView: UIImageView!
        @IBOutlet weak var awayTeamNameLabel: UILabel!
        @IBOutlet weak var awayScoreLabel: UILabel!
        
        @IBOutlet weak var matchStatusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let backgroundTarget = containerView ?? contentView.subviews.first ?? contentView
        backgroundTarget.backgroundColor = .clear
        backgroundTarget.layer.cornerRadius = 12
        backgroundTarget.clipsToBounds = true
        
        // --- Programmatically restructure the views first ---
        // Save reference to the score stack (superview of homeScoreLabel)
        let scoreStack = homeScoreLabel.superview
        
        // Detach all IBOutlet views
        homeTeamImageView.removeFromSuperview()
        homeTeamNameLabel.removeFromSuperview()
        awayTeamImageView.removeFromSuperview()
        awayTeamNameLabel.removeFromSuperview()
        scoreStack?.removeFromSuperview()
        matchStatusLabel.removeFromSuperview()
        
        // Remove ALL old layout stack views from the card view
        backgroundTarget.subviews.forEach { $0.removeFromSuperview() }
        
        // --- Now add grass2 background + overlay FIRST (on clean container) ---
        let bgImageView = UIImageView(image: UIImage(named: "grass2"))
        bgImageView.contentMode = .scaleAspectFill
        bgImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundTarget.addSubview(bgImageView)
        
        let overlay = UIView()
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.45)
        overlay.translatesAutoresizingMaskIntoConstraints = false
        backgroundTarget.addSubview(overlay)
        
        NSLayoutConstraint.activate([
            bgImageView.topAnchor.constraint(equalTo: backgroundTarget.topAnchor),
            bgImageView.leadingAnchor.constraint(equalTo: backgroundTarget.leadingAnchor),
            bgImageView.trailingAnchor.constraint(equalTo: backgroundTarget.trailingAnchor),
            bgImageView.bottomAnchor.constraint(equalTo: backgroundTarget.bottomAnchor),
            overlay.topAnchor.constraint(equalTo: backgroundTarget.topAnchor),
            overlay.leadingAnchor.constraint(equalTo: backgroundTarget.leadingAnchor),
            overlay.trailingAnchor.constraint(equalTo: backgroundTarget.trailingAnchor),
            overlay.bottomAnchor.constraint(equalTo: backgroundTarget.bottomAnchor),
        ])
        
        // --- Re-add content views on top of background ---
        backgroundTarget.addSubview(homeTeamImageView)
        backgroundTarget.addSubview(homeTeamNameLabel)
        backgroundTarget.addSubview(awayTeamImageView)
        backgroundTarget.addSubview(awayTeamNameLabel)
        
        if let scoreStack = scoreStack {
            backgroundTarget.addSubview(scoreStack)
        }
        backgroundTarget.addSubview(matchStatusLabel)
        
        homeTeamImageView.translatesAutoresizingMaskIntoConstraints = false
        homeTeamNameLabel.translatesAutoresizingMaskIntoConstraints = false
        awayTeamImageView.translatesAutoresizingMaskIntoConstraints = false
        awayTeamNameLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreStack?.translatesAutoresizingMaskIntoConstraints = false
        matchStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // --- Text colors ---
        homeTeamNameLabel.textColor = .white
        homeScoreLabel.textColor = .white
        awayTeamNameLabel.textColor = .white
        awayScoreLabel.textColor = .white
        matchStatusLabel.textColor = UIColor.white.withAlphaComponent(0.7)
        
        var constraints = [NSLayoutConstraint]()
        
        if let scoreStack = scoreStack {
            constraints.append(contentsOf: [
                // Score stack perfectly centered horizontally and vertically
                scoreStack.centerXAnchor.constraint(equalTo: backgroundTarget.centerXAnchor),
                scoreStack.centerYAnchor.constraint(equalTo: backgroundTarget.centerYAnchor, constant: -12),
            ])
            
            // Match status label (FT / Date) centered horizontally directly below the score stack
            constraints.append(contentsOf: [
                matchStatusLabel.topAnchor.constraint(equalTo: scoreStack.bottomAnchor, constant: 8),
                matchStatusLabel.centerXAnchor.constraint(equalTo: backgroundTarget.centerXAnchor)
            ])
        } else {
            constraints.append(contentsOf: [
                matchStatusLabel.centerXAnchor.constraint(equalTo: backgroundTarget.centerXAnchor),
                matchStatusLabel.centerYAnchor.constraint(equalTo: backgroundTarget.centerYAnchor, constant: 16)
            ])
        }
        
        constraints.append(contentsOf: [
            // Home Team Logo (Left) aligned vertically with score stack
            homeTeamImageView.leadingAnchor.constraint(equalTo: backgroundTarget.leadingAnchor, constant: 28),
            homeTeamImageView.centerYAnchor.constraint(equalTo: backgroundTarget.centerYAnchor, constant: -12),
            homeTeamImageView.widthAnchor.constraint(equalToConstant: 44),
            homeTeamImageView.heightAnchor.constraint(equalToConstant: 44),
            
            // Home Team Name centered below Home Team Logo
            homeTeamNameLabel.topAnchor.constraint(equalTo: homeTeamImageView.bottomAnchor, constant: 8),
            homeTeamNameLabel.centerXAnchor.constraint(equalTo: homeTeamImageView.centerXAnchor),
            homeTeamNameLabel.leadingAnchor.constraint(greaterThanOrEqualTo: backgroundTarget.leadingAnchor, constant: 8),
            homeTeamNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: scoreStack?.leadingAnchor ?? backgroundTarget.centerXAnchor, constant: -8),
            
            // Away Team Logo (Right) aligned vertically with score stack
            awayTeamImageView.trailingAnchor.constraint(equalTo: backgroundTarget.trailingAnchor, constant: -28),
            awayTeamImageView.centerYAnchor.constraint(equalTo: backgroundTarget.centerYAnchor, constant: -12),
            awayTeamImageView.widthAnchor.constraint(equalToConstant: 44),
            awayTeamImageView.heightAnchor.constraint(equalToConstant: 44),
            
            // Away Team Name centered below Away Team Logo
            awayTeamNameLabel.topAnchor.constraint(equalTo: awayTeamImageView.bottomAnchor, constant: 8),
            awayTeamNameLabel.centerXAnchor.constraint(equalTo: awayTeamImageView.centerXAnchor),
            awayTeamNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: backgroundTarget.trailingAnchor, constant: -8),
            awayTeamNameLabel.leadingAnchor.constraint(greaterThanOrEqualTo: scoreStack?.trailingAnchor ?? backgroundTarget.centerXAnchor, constant: 8)
        ])
        
        NSLayoutConstraint.activate(constraints)
        
        // Ensure image views have perfect aspect fit & clipsToBounds
        homeTeamImageView.contentMode = .scaleAspectFit
        awayTeamImageView.contentMode = .scaleAspectFit
        
        homeTeamNameLabel.textAlignment = .center
        awayTeamNameLabel.textAlignment = .center
        
        homeTeamNameLabel.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        awayTeamNameLabel.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        
        homeTeamNameLabel.numberOfLines = 2
        awayTeamNameLabel.numberOfLines = 2
        homeTeamNameLabel.lineBreakMode = .byWordWrapping
        awayTeamNameLabel.lineBreakMode = .byWordWrapping
    }

    func configure(homeImage: String?, homeName: String, homeScore: String, awayImage: String?, awayName: String, awayScore: String, status: String) {
        homeTeamNameLabel.text = homeName
        homeScoreLabel.text = homeScore
        awayTeamNameLabel.text = awayName
        awayScoreLabel.text = awayScore
        matchStatusLabel.text = status
        
        // Ensure text colors remain white (grass bg always visible)
        homeTeamNameLabel.textColor = .white
        homeScoreLabel.textColor = .white
        awayTeamNameLabel.textColor = .white
        awayScoreLabel.textColor = .white
        matchStatusLabel.textColor = UIColor.white.withAlphaComponent(0.7)
        
        let placeholder = UIImage(systemName: "photo.circle")
        
        if let homeStr = homeImage, let homeUrl = URL(string: homeStr) {
            homeTeamImageView.kf.setImage(with: homeUrl, placeholder: placeholder)
        } else {
            homeTeamImageView.image = placeholder
        }
        
        if let awayStr = awayImage, let awayUrl = URL(string: awayStr) {
            awayTeamImageView.kf.setImage(with: awayUrl, placeholder: placeholder)
        } else {
            awayTeamImageView.image = placeholder
        }
    }
}
