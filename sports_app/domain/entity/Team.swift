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
    
    let players: [Player]?
}

struct Player: Codable {
    let playerKey: Int?
    let playerName: String?
    let playerNumber: String?
    let playerImage: String?
    let playerType: String?
    let playerAge: String?
    let playerMatchPlayed: String?
    let playerGoals: String?
    let playerYellowCards: String?
    let playerRedCards: String?
    let playerRating: String?
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
