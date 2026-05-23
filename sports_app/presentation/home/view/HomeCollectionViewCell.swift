//
//  HomeCollectionViewCell.swift
//  sports_app
//
//  Created by Thaowpsta Saiid on 23/05/2026.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var sportImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupStyling()
    }
    
    private func setupStyling() {
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
    }
    
    func configure(with sport: SportCard) {
        nameLabel.text = sport.name
        sportImageView.image = UIImage(named: sport.imageName)
        sportImageView.backgroundColor = sport.iconBackgroundColor
        sportImageView.contentMode = .scaleAspectFill
        sportImageView.clipsToBounds = true
    }
}
