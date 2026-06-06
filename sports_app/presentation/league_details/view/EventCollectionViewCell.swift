//
//  EventCollectionViewCell.swift
//  sports_app
//
//  Created by Thaowpsta Saiid on 29/05/2026.
//

import UIKit
import Kingfisher

class EventCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var homeTeamImageView: UIImageView!
    @IBOutlet weak var awayTeamImageView: UIImageView!
    @IBOutlet weak var matchNameLabel: UILabel!
    @IBOutlet weak var matchDateLabel: UILabel!
    
    private var grassImageView: UIImageView?
    private var overlayView: UIView?

    // Labels for team names shown below the logos
    private let homeNameLabel = UILabel()
    private let awayNameLabel = UILabel()
    // Bold VS label shown between logos
    private let vsLabel = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()

        let card = contentView.subviews.first ?? contentView
        card.backgroundColor = .clear
        card.layer.cornerRadius = 16
        card.clipsToBounds = true

        // --- Grass background + dark overlay ---
        let bgIV = UIImageView(image: UIImage(named: "grass"))
        bgIV.contentMode = .scaleAspectFill
        bgIV.translatesAutoresizingMaskIntoConstraints = false
        card.insertSubview(bgIV, at: 0)
        grassImageView = bgIV

        let ov = UIView()
        ov.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        ov.translatesAutoresizingMaskIntoConstraints = false
        card.insertSubview(ov, aboveSubview: bgIV)
        overlayView = ov

        NSLayoutConstraint.activate([
            bgIV.topAnchor.constraint(equalTo: card.topAnchor),
            bgIV.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            bgIV.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            bgIV.bottomAnchor.constraint(equalTo: card.bottomAnchor),
            ov.topAnchor.constraint(equalTo: card.topAnchor),
            ov.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            ov.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            ov.bottomAnchor.constraint(equalTo: card.bottomAnchor),
        ])


        homeTeamImageView.removeFromSuperview()
        awayTeamImageView.removeFromSuperview()
        matchNameLabel.removeFromSuperview()
        matchDateLabel.removeFromSuperview()

  
        for sub in card.subviews where sub !== bgIV && sub !== ov {
            sub.removeFromSuperview()
        }

       
        card.addSubview(homeTeamImageView)
        card.addSubview(awayTeamImageView)
        card.addSubview(vsLabel)
        card.addSubview(matchDateLabel)
        card.addSubview(homeNameLabel)
        card.addSubview(awayNameLabel)
        

        homeTeamImageView.translatesAutoresizingMaskIntoConstraints = false
        awayTeamImageView.translatesAutoresizingMaskIntoConstraints = false
        vsLabel.translatesAutoresizingMaskIntoConstraints = false
        matchDateLabel.translatesAutoresizingMaskIntoConstraints = false
        homeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        awayNameLabel.translatesAutoresizingMaskIntoConstraints = false

        // Style
        homeTeamImageView.contentMode = .scaleAspectFit
        awayTeamImageView.contentMode = .scaleAspectFit

        vsLabel.text = "VS"
        vsLabel.textColor = .white
        vsLabel.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        vsLabel.textAlignment = .center

        matchDateLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        matchDateLabel.font = UIFont.systemFont(ofSize: 8, weight: .regular)
        matchDateLabel.textAlignment = .center

        for lbl in [homeNameLabel, awayNameLabel] {
            lbl.textColor = .white
            lbl.font = UIFont.systemFont(ofSize: 9, weight: .semibold)
            lbl.textAlignment = .center
            lbl.numberOfLines = 2
            lbl.lineBreakMode = .byWordWrapping
        }


        NSLayoutConstraint.activate([
            // Home logo – left side
            homeTeamImageView.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
            homeTeamImageView.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
            homeTeamImageView.widthAnchor.constraint(equalToConstant: 36),
            homeTeamImageView.heightAnchor.constraint(equalToConstant: 36),

            // Away logo – right side
            awayTeamImageView.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -12),
            awayTeamImageView.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
            awayTeamImageView.widthAnchor.constraint(equalToConstant: 36),
            awayTeamImageView.heightAnchor.constraint(equalToConstant: 36),

            // VS centered between logos
            vsLabel.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            vsLabel.centerYAnchor.constraint(equalTo: homeTeamImageView.centerYAnchor),

            // Date centered below VS
            matchDateLabel.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            matchDateLabel.topAnchor.constraint(equalTo: vsLabel.bottomAnchor, constant: 2),

            // Home name below home logo
            homeNameLabel.topAnchor.constraint(equalTo: homeTeamImageView.bottomAnchor, constant: 6),
            homeNameLabel.centerXAnchor.constraint(equalTo: homeTeamImageView.centerXAnchor),
            homeNameLabel.leadingAnchor.constraint(greaterThanOrEqualTo: card.leadingAnchor, constant: 4),
            homeNameLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 80),

            // Away name below away logo
            awayNameLabel.topAnchor.constraint(equalTo: awayTeamImageView.bottomAnchor, constant: 6),
            awayNameLabel.centerXAnchor.constraint(equalTo: awayTeamImageView.centerXAnchor),
            awayNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: card.trailingAnchor, constant: -4),
            awayNameLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 80),
        ])
    }

    func configure(
        homeImage: String,
        awayImage: String,
        name: String,
        date: String
    ) {
        let placeholder = UIImage(systemName: "photo.circle")

        if let homeUrl = URL(string: homeImage), !homeImage.isEmpty {
            homeTeamImageView.kf.setImage(with: homeUrl, placeholder: placeholder)
        } else {
            homeTeamImageView.image = placeholder
        }

        if let awayUrl = URL(string: awayImage), !awayImage.isEmpty {
            awayTeamImageView.kf.setImage(with: awayUrl, placeholder: placeholder)
        } else {
            awayTeamImageView.image = placeholder
        }

        // Parse "Home vs Away" into separate labels
        let parts = name.components(separatedBy: " vs ")
        homeNameLabel.text = parts.first ?? ""
        awayNameLabel.text = parts.count > 1 ? parts[1] : ""

        matchDateLabel.text = date
    }
}
