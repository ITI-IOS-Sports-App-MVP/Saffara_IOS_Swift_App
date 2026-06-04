//
//  AllSportsResponse.swift
//  sports_app
//
//  Created by Thaowpsta Saiid on 30/05/2026.
//

import Foundation
import Combine

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
        leagueKey: Int
    ) -> AnyPublisher<[Event], Error> {
        leaguesNetworkService.fetchUpcomingEvents(sportName: sportName, leagueKey: leagueKey)
    }

    func fetchLatestResults(
        leagueKey: Int
    ) -> AnyPublisher<[Event], Error> {
        leaguesNetworkService.fetchLatestResults(sportName: sportName, leagueKey: leagueKey)
    }

    func fetchTeams(
        leagueKey: Int
    ) -> AnyPublisher<[Team], Error> {
        teamsNetworkService.fetchTeams(sportName: sportName, leagueKey: leagueKey)
    }
}
