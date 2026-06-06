//
//  TeamDetailsRepository.swift
//  sports_app
//

import Foundation
import Combine

class TeamDetailsRepository: TeamDetailsRepoProtocol {
    
    private let networkService: TeamsNetworkServiceProtocol
    
    init(networkService: TeamsNetworkServiceProtocol = TeamsNetworkService()) {
        self.networkService = networkService
    }
    
    func fetchTeamDetails(sport: String, teamId: Int) -> AnyPublisher<[Team], Error> {
        networkService.fetchTeamDetails(sportName: sport, teamId: teamId)
    }
}
