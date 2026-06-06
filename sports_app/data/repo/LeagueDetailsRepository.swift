//
//  LeagueDetailsRepository.swift
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
    private let localDataSource: CoreDataManagerProtocol

    init(
        sport: String,
        leaguesNetworkService: LeaguesNetworkServiceProtocol = LeaguesNetworkService(),
        teamsNetworkService: TeamsNetworkServiceProtocol = TeamsNetworkService(),
        localDataSource: CoreDataManagerProtocol = CoreDataManager.shared // Injected local source
    ) {
        self.sportName = sport.lowercased().trimmingCharacters(in: .whitespaces)
        self.leaguesNetworkService = leaguesNetworkService
        self.teamsNetworkService = teamsNetworkService
        self.localDataSource = localDataSource
    }

    func fetchUpcomingEvents(
        leagueKey: Int
    ) -> AnyPublisher<[Event], Error> {
        if NetworkMonitor.shared.isConnected {
            return leaguesNetworkService.fetchUpcomingEvents(sportName: sportName, leagueKey: leagueKey)
                .handleEvents(receiveOutput: { [weak self] events in
                    try? self?.localDataSource.saveEvents(events, for: leagueKey, type: "upcoming")
                })
                .eraseToAnyPublisher()
        } else {
            do {
                let cachedEvents = try localDataSource.fetchCachedEvents(for: leagueKey, type: "upcoming")
                return Just(cachedEvents).setFailureType(to: Error.self).eraseToAnyPublisher()
            } catch {
                return Fail(error: error).eraseToAnyPublisher()
            }
        }
    }

    func fetchLatestResults(
        leagueKey: Int
    ) -> AnyPublisher<[Event], Error> {
        if NetworkMonitor.shared.isConnected {
            return leaguesNetworkService.fetchLatestResults(sportName: sportName, leagueKey: leagueKey)
                .handleEvents(receiveOutput: { [weak self] events in
                    try? self?.localDataSource.saveEvents(events, for: leagueKey, type: "latest")
                })
                .eraseToAnyPublisher()
        } else {
            do {
                let cachedEvents = try localDataSource.fetchCachedEvents(for: leagueKey, type: "latest")
                return Just(cachedEvents).setFailureType(to: Error.self).eraseToAnyPublisher()
            } catch {
                return Fail(error: error).eraseToAnyPublisher()
            }
        }
    }

    func fetchTeams(
        leagueKey: Int
    ) -> AnyPublisher<[Team], Error> {
        if NetworkMonitor.shared.isConnected {
            return teamsNetworkService.fetchTeams(sportName: sportName, leagueKey: leagueKey)
                .handleEvents(receiveOutput: { [weak self] teams in
                    try? self?.localDataSource.saveTeams(teams, for: leagueKey)
                })
                .eraseToAnyPublisher()
        } else {
            do {
                let cachedTeams = try localDataSource.fetchCachedTeams(for: leagueKey)
                return Just(cachedTeams).setFailureType(to: Error.self).eraseToAnyPublisher()
            } catch {
                return Fail(error: error).eraseToAnyPublisher()
            }
        }
    }
}
