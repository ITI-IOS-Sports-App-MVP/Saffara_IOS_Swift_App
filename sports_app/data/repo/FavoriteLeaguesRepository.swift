//
//  FavoriteLeaguesRepository.swift
//  sports_app
//
//  Created by Thaowpsta Saiid on 25/05/2026.
//

class FavoriteLeaguesRepository: FavoriteLeaguesRepoProtocol {
    private let localDataSource: CoreDataManagerProtocol

    init(localDataSource: CoreDataManagerProtocol = CoreDataManager.shared) {
        self.localDataSource = localDataSource
    }

    func getFavoriteLeagues() throws -> [League] {
        return try localDataSource.fetchFavorites()
    }

    func addLeagueToFavorites(league: League) throws {
        try localDataSource.saveFavorite(league: league)
    }

    func removeLeagueFromFavorites(leagueKey: Int) throws {
        try localDataSource.deleteFavorite(leagueKey: leagueKey)
    }
}
