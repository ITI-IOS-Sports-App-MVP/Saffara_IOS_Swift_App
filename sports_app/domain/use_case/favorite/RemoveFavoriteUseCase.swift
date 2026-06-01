//
//  RemoveFavoriteUseCase.swift
//  sports_app
//
//  Created by Thaowpsta Saiid on 25/05/2026.
//


class RemoveFavoriteUseCase: RemoveFavoriteUseCaseProtocol {
    private let repository: FavoriteLeaguesRepoProtocol
    
    init(repository: FavoriteLeaguesRepoProtocol) {
        self.repository = repository
    }
    
    func execute(leagueKey: Int) throws {
        try repository.removeLeagueFromFavorites(leagueKey: leagueKey)
    }
}
