//
//  GetLatestResultsUseCase.swift
//  sports_app
//
//  Created by Thaowpsta Saiid on 30/05/2026.
//

class GetLatestResultsUseCase: GetLatestResultsUseCaseProtocol {
    private let repository: LeagueDetailsRepoProtocol
    init(repository: LeagueDetailsRepoProtocol) { self.repository = repository }
    
    func execute(leagueId: Int, completion: @escaping (Result<[Event], Error>) -> Void) {
        repository.fetchLatestResults(leagueId: leagueId, completion: completion)
    }
}
