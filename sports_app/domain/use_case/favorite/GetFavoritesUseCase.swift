//
//  GetFavoritesUseCase.swift
//  sports_app
//
//  Created by Thaowpsta Saiid on 25/05/2026.
//


class GetFavoritesUseCase: GetFavoritesUseCaseProtocol {
    private let repository: FavoriteLeaguesRepoProtocol
    
    init(repository: FavoriteLeaguesRepoProtocol) {
        self.repository = repository
    }
    
    func execute() throws -> [League] {
        return try repository.getFavoriteLeagues()
    }
}
