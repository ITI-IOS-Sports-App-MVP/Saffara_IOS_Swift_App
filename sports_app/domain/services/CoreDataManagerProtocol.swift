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
}