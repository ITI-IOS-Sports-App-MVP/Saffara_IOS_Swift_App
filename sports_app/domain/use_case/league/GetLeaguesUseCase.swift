//
//  GetLeaguesUseCase.swift
//  sports_app
//
//  Created by Thaowpsta Saiid on 23/05/2026.
//


class GetLeaguesUseCase: GetLeaguesUseCaseProtocol {
    private let repository: LeaguesRepoProtocol
    
    init(repository: LeaguesRepoProtocol) {
        self.repository = repository
    }
    
    func execute(sportName: String, completion: @escaping (Result<[League], Error>) -> Void) {
        repository.fetchLeagues(sportName: sportName, completion: completion)
    }
}