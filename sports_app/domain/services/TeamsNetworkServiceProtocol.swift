//
//  TeamsNetworkServiceProtocol.swift
//  sports_app
//

import Foundation

protocol TeamsNetworkServiceProtocol {
    func fetchTeams(sportName: String, leagueKey: Int, completion: @escaping (Result<[Team], Error>) -> Void)
    func fetchTeamDetails(sportName: String, teamId: Int, completion: @escaping (Result<[Team], Error>) -> Void)
}
