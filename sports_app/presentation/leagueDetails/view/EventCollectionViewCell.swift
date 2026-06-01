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

        homeTeamImageView.layer.cornerRadius =
            homeTeamImageView.frame.height / 2
        awayTeamImageView.layer.cornerRadius =
            awayTeamImageView.frame.height / 2
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
