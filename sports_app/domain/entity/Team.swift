//
//  Team.swift
//  sports_app
//
//  Created by Thaowpsta Saiid on 30/05/2026.
//


struct Team: Codable {
    let teamKey: Int?
    let teamName: String?
    let teamLogo: String?
    
    let playerKey: Int?
    let playerName: String?
    let playerLogo: String?
    let playerImage: String?
}

extension Team {
    var displayTeamName: String {
        return teamName ?? playerName ?? "Unknown"
    }
    
    var displayTeamLogo: String? {
        let logo = teamLogo ?? playerLogo ?? playerImage
        return (logo?.trimmingCharacters(in: .whitespaces).isEmpty == false) ? logo : nil
    }
}
