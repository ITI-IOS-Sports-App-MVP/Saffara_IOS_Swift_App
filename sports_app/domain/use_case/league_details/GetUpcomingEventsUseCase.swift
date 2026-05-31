//
//  GetUpcomingEventsUseCase.swift
//  sports_app
//
//  Created by Thaowpsta Saiid on 30/05/2026.
//


class GetUpcomingEventsUseCase: GetUpcomingEventsUseCaseProtocol {
    private let repository: LeagueDetailsRepoProtocol
    
    init(repository: LeagueDetailsRepoProtocol) { self.repository = repository }
    
    func execute(leagueKey: Int, completion: @escaping (Result<[Event], Error>) -> Void) {
        repository.fetchUpcomingEvents(leagueKey: leagueKey, completion: completion)
    }
}
