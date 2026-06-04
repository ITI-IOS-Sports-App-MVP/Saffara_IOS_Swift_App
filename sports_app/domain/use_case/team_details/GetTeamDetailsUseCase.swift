//
//  GetTeamDetailsUseCase.swift
//  sports_app
//

import Foundation
import Combine

class GetTeamDetailsUseCase: GetTeamDetailsUseCaseProtocol {
    private let repository: TeamDetailsRepoProtocol
    
    init(repository: TeamDetailsRepoProtocol) {
        self.repository = repository
    }
    
    func execute(sport: String, teamId: Int) -> AnyPublisher<[Team], Error> {
        repository.fetchTeamDetails(sport: sport, teamId: teamId)
    }
}
