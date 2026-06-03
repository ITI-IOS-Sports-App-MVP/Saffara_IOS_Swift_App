//
//  TeamDetailsRepository.swift
//  sports_app
//

import Foundation

class TeamDetailsRepository: TeamDetailsRepoProtocol {
    
    private let networkService: TeamsNetworkServiceProtocol
    
    init(networkService: TeamsNetworkServiceProtocol = TeamsNetworkService()) {
        self.networkService = networkService
    }
    
    func fetchTeamDetails(sport: String, teamId: Int, completion: @escaping (Result<[Team], Error>) -> Void) {
        networkService.fetchTeamDetails(sportName: sport, teamId: teamId, completion: completion)
    }
}
