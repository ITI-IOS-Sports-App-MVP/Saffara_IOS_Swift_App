//
//  GetTeamsUseCase 2.swift
//  sports_app
//
//  Created by Thaowpsta Saiid on 30/05/2026.
//


class GetTeamsUseCase: GetTeamsUseCaseProtocol {
    private let repository: LeagueDetailsRepoProtocol
    init(repository: LeagueDetailsRepoProtocol) { self.repository = repository }
    
    func execute(leagueId: Int, completion: @escaping (Result<[Team], Error>) -> Void) {
        repository.fetchTeams(leagueId: leagueId, completion: completion)
    }
}