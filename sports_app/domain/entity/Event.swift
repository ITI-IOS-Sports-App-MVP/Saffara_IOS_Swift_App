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
    let homeTeamLogo: String?
    let awayTeamLogo: String?
    let eventHomeTeamLogo: String?
    let eventAwayTeamLogo: String?
    
    let eventFirstPlayer: String?
    let eventSecondPlayer: String?
    let eventFirstPlayerLogo: String?
    let eventSecondPlayerLogo: String?
    let eventHomePlayer: String?
    let eventAwayPlayer: String?
    
    let eventFinalResult: String?
    let eventDateStart: String?
    let eventHomeFinalResult: String?
    let eventAwayFinalResult: String?
}

// MARK: - Displayable Data Formatters
extension Event {
    var displayDate: String {
        return eventDate ?? eventDateStart ?? "Time: \(eventTime ?? "")"
    }
    
    var displayHomeLogo: String? {
        let logo = homeTeamLogo ?? eventHomeTeamLogo ?? eventFirstPlayerLogo
        return (logo?.trimmingCharacters(in: .whitespaces).isEmpty == false) ? logo : nil
    }
    
    var displayAwayLogo: String? {
        let logo = awayTeamLogo ?? eventAwayTeamLogo ?? eventSecondPlayerLogo
        return (logo?.trimmingCharacters(in: .whitespaces).isEmpty == false) ? logo : nil
    }
    
    var displayHomeName: String {
        return eventHomeTeam ?? eventFirstPlayer ?? eventHomePlayer ?? "Unknown Player"
    }
    
    var displayAwayName: String {
        return eventAwayTeam ?? eventSecondPlayer ?? eventAwayPlayer ?? "Unknown Player"
    }
    
    var displayHomeScore: String {
        if let combinedResult = eventFinalResult,
           combinedResult.contains("-"),
           combinedResult.trimmingCharacters(in: .whitespacesAndNewlines) != "-" {
            
            let scores = combinedResult.components(separatedBy: "-")
            return scores.first?.trimmingCharacters(in: .whitespaces) ?? "N/A"
        }
        return eventHomeFinalResult ?? "N/A"
    }
    
    var displayAwayScore: String {
        if let combinedResult = eventFinalResult,
           combinedResult.contains("-"),
           combinedResult.trimmingCharacters(in: .whitespacesAndNewlines) != "-" {
            
            let scores = combinedResult.components(separatedBy: "-")
            return scores.count > 1 ? scores.last?.trimmingCharacters(in: .whitespaces) ?? "-" : "N/A"
        }
        return eventAwayFinalResult ?? "N/A "
    }
}
