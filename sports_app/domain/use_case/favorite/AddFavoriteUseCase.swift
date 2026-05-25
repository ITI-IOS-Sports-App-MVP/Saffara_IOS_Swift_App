//
//  AddFavoriteUseCase.swift
//  sports_app
//
//  Created by Thaowpsta Saiid on 25/05/2026.
//


class AddFavoriteUseCase: AddFavoriteUseCaseProtocol {
    private let repository: FavoriteLeaguesRepoProtocol
    
    init(repository: FavoriteLeaguesRepoProtocol) {
        self.repository = repository
    }
    
    func execute(league: League) throws {
        try repository.addLeagueToFavorites(league: league)
    }
}
