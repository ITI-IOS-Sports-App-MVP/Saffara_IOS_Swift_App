//
//  FavoriteLeaguesRepoProtocol.swift
//  sports_app
//
//  Created by Thaowpsta Saiid on 25/05/2026.
//


protocol FavoriteLeaguesRepoProtocol {
    func getFavoriteLeagues() throws -> [League]
    func addLeagueToFavorites(league: League) throws
    func removeLeagueFromFavorites(leagueKey: Int) throws
}
