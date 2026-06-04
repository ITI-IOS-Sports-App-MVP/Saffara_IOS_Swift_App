//
//  OfflineSyncManager.swift
//  sports_app
//
//  Created by Thaowpsta Saiid on 04/06/2026.
//

import Foundation
import Combine

class OfflineSyncManager {
    static let shared = OfflineSyncManager()
    
    private let leaguesNetwork = LeaguesNetworkService()
    private let teamsNetwork = TeamsNetworkService()
    private let coreData = CoreDataManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    let supportedSports = ["football", "basketball", "tennis", "cricket"]
    
    private init() {}
    
    func startBackgroundSync() {
        guard NetworkMonitor.shared.isConnected else { return }
        print("Starting sequential background sync...")
        
        Publishers.Sequence(sequence: supportedSports)
            .flatMap(maxPublishers: .max(1)) { sport -> AnyPublisher<Void, Never> in
                self.syncSport(sportName: sport)
            }
            .sink(receiveCompletion: { _ in
                print("Offline Background Sync completely finished!")
            }, receiveValue: { _ in })
            .store(in: &cancellables)
    }
    
    private func syncSport(sportName: String) -> AnyPublisher<Void, Never> {
        return leaguesNetwork.fetchLeagues(sportName: sportName)
            .map { Array($0.prefix(10)) }
            .handleEvents(receiveOutput: { [weak self] leagues in
                try? self?.coreData.saveLeagues(leagues, for: sportName)
            })
            .flatMap(maxPublishers: .max(1)) { leagues -> AnyPublisher<Void, Never> in
                
                let leagueKeys = leagues.compactMap { $0.leagueKey }
                let detailPublishers = leagueKeys.map { self.syncLeagueDetails(leagueKey: $0, sportName: sportName) }
                
                return Publishers.Sequence(sequence: detailPublishers)
                    .flatMap(maxPublishers: .max(1)) { $0 }
                    .eraseToAnyPublisher()
            }
            .catch { _ in Just(()) }
            .eraseToAnyPublisher()
    }
    
    private func syncLeagueDetails(leagueKey: Int, sportName: String) -> AnyPublisher<Void, Never> {
        return Publishers.Zip3(
            leaguesNetwork.fetchUpcomingEvents(sportName: sportName, leagueKey: leagueKey).catch { _ in Just([]) },
            leaguesNetwork.fetchLatestResults(sportName: sportName, leagueKey: leagueKey).catch { _ in Just([]) },
            teamsNetwork.fetchTeams(sportName: sportName, leagueKey: leagueKey).catch { _ in Just([]) }
        )
        .handleEvents(receiveOutput: { [weak self] upcoming, latest, teams in
            try? self?.coreData.saveEvents(upcoming, for: leagueKey, type: "upcoming")
            try? self?.coreData.saveEvents(latest, for: leagueKey, type: "latest")
            try? self?.coreData.saveTeams(teams, for: leagueKey)
            print("Cached details for \(sportName) league ID: \(leagueKey)")
        })
        .map { _ in () }
        .delay(for: .seconds(1), scheduler: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
