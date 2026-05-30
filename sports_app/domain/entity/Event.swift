//
//  Event.swift
//  sports_app
//
//  Created by Thaowpsta Saiid on 30/05/2026.
//


struct Event: Codable {
    let eventKey: Int?
    let eventDate: String?
    let eventTime: String?
    let eventHomeTeam: String?
    let eventAwayTeam: String?
    let eventFinalResult: String?
    let homeTeamLogo: String?
    let awayTeamLogo: String?
}