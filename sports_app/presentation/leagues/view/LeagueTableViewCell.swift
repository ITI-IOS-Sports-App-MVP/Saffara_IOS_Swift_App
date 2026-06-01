//
//  LeagueTableViewCell.swift
//  sports_app
//
//  Created by Thaowpsta Saiid on 23/05/2026.
//

import UIKit

class LeagueTableViewCell: UITableViewCell, LeagueCellViewProtocol {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var leagueImageView: UIImageView!
    @IBOutlet weak var leagueNameLabel: UILabel!
    @IBOutlet weak var chevronImageView: UIImageView!
    @IBOutlet weak var countryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func displayLeagueName(_ name: String) {
        leagueNameLabel.text = name
    }
    
    func displayLeagueBadge(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        DispatchQueue.global(qos: .background).async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.leagueImageView.image = image
                }
            }
        }
    }
    
    func displayLeagueCountry(_ country: String) {
            countryLabel.text = country
        }
    
}
