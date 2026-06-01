//
//  TeamCircleCollectionViewCell.swift
//  sports_app
//
//  Created by Thaowpsta Saiid on 30/05/2026.
//

import Kingfisher
import UIKit

class TeamCircleCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var NameLabelView: UILabel!
    @IBOutlet weak var teamImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(name: String, imageUrl: String?) {
        NameLabelView.text = name

        let placeholder = UIImage(systemName: "person.circle.fill")

        if let urlString = imageUrl, let url = URL(string: urlString) {
            teamImageView.kf.setImage(with: url, placeholder: placeholder)
        } else {
            teamImageView.image = placeholder
        }
    }
}
