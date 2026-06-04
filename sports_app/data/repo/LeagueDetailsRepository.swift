//
//  AllSportsResponse.swift
//  sports_app
//
//  Created by Thaowpsta Saiid on 30/05/2026.
//

import Foundation



class LeagueDetailsRepository: LeagueDetailsRepoProtocol {

    private let sportName: String
    private let leaguesNetworkService: LeaguesNetworkServiceProtocol
    private let teamsNetworkService: TeamsNetworkServiceProtocol

    init(
        sport: String,
        leaguesNetworkService: LeaguesNetworkServiceProtocol = LeaguesNetworkService(),
        teamsNetworkService: TeamsNetworkServiceProtocol = TeamsNetworkService()
    ) {
        self.sportName = sport.lowercased().trimmingCharacters(in: .whitespaces)
        self.leaguesNetworkService = leaguesNetworkService
        self.teamsNetworkService = teamsNetworkService
    }

    func fetchUpcomingEvents(
        leagueKey: Int,
        completion: @escaping (Result<[Event], Error>) -> Void
    ) {
        leaguesNetworkService.fetchUpcomingEvents(sportName: sportName, leagueKey: leagueKey, completion: completion)
    }

    func fetchLatestResults(
        leagueKey: Int,
        completion: @escaping (Result<[Event], Error>) -> Void
    ) {
        leaguesNetworkService.fetchLatestResults(sportName: sportName, leagueKey: leagueKey, completion: completion)
    }

    func fetchTeams(
        leagueKey: Int,
        completion: @escaping (Result<[Team], Error>) -> Void
    ) {
        teamsNetworkService.fetchTeams(sportName: sportName, leagueKey: leagueKey, completion: completion)
    }
}
