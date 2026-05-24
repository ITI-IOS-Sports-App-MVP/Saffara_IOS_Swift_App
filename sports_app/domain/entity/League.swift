//
//  League.swift
//  sports_app
//
//  Created by Thaowpsta Saiid on 23/05/2026.
//


struct League: Codable {
    let leagueKey: Int?
    let leagueName: String?
    let leagueLogo: String?
    let leagueCountry: String?
    
    enum CodingKeys: String, CodingKey {
        case leagueKey = "league_key"
        case leagueName = "league_name"
        case leagueLogo = "league_logo"
        case leagueCountry = "country_name"
    }
}
