//
//  CoreDataManagerProtocol.swift
//  sports_app
//
//  Created by Abdullh Gaber on 04/06/2026.
//


protocol CoreDataManagerProtocol {
    func fetchFavorites() throws -> [League]
    func saveFavorite(league: League) throws
    func deleteFavorite(leagueKey: Int) throws
    
    func fetchCachedLeagues(for sportName: String) throws -> [League]
    func saveLeagues(_ leagues: [League], for sportName: String) throws
    
    func saveTeams(_ teams: [Team], for leagueKey: Int) throws
    func fetchCachedTeams(for leagueKey: Int) throws -> [Team]

    func saveEvents(_ events: [Event], for leagueKey: Int, type: String) throws
    func fetchCachedEvents(for leagueKey: Int, type: String) throws -> [Event]
}
