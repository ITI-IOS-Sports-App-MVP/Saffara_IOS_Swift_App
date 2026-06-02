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

    override func awakeFromNib() {
        super.awakeFromNib()
            
            
        // Safely style the first subview (container view in XIB) or contentView
        let backgroundTarget = contentView.subviews.first ?? contentView
        backgroundTarget.backgroundColor = .secondarySystemGroupedBackground
        backgroundTarget.layer.cornerRadius = 12
        backgroundTarget.clipsToBounds = true
        
        matchNameLabel.textColor = .label
        matchDateLabel.textColor = .secondaryLabel
    }

    func configure(
        homeImage: String,
        awayImage: String,
        name: String,
        date: String
    ) {
        let placeholder = UIImage(systemName: "sportscourt.fill")
                
                if let homeUrl = URL(string: homeImage) {
                    homeTeamImageView.kf.setImage(with: homeUrl, placeholder: placeholder)
                } else {
                    homeTeamImageView.image = placeholder
                }
                
                if let awayUrl = URL(string: awayImage) {
                    awayTeamImageView.kf.setImage(with: awayUrl, placeholder: placeholder)
                } else {
                    awayTeamImageView.image = placeholder
                }
            }
}
