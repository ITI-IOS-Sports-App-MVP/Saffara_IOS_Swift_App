//
//  TeamsNetworkServiceProtocol.swift
//  sports_app
//

import Foundation
import Combine

protocol TeamsNetworkServiceProtocol {
    func fetchTeams(sportName: String, leagueKey: Int) -> AnyPublisher<[Team], Error>
    func fetchTeamDetails(sportName: String, teamId: Int) -> AnyPublisher<[Team], Error>
}
