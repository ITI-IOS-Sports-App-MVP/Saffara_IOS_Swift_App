//
//  LeaguesRepository.swift
//  sports_app
//
//  Created by Thaowpsta Saiid on 23/05/2026.
//

import Alamofire
import Foundation
import Combine

class LeaguesRepository: LeaguesRepoProtocol {

    private let networkService: LeaguesNetworkServiceProtocol
    let localDataSource: CoreDataManagerProtocol

    init(networkService: LeaguesNetworkServiceProtocol = LeaguesNetworkService(), localDataSource: CoreDataManagerProtocol) {
        self.networkService = networkService
        self.localDataSource = localDataSource
    }

    func fetchLeagues(
        sportName: String
    ) -> AnyPublisher<[League], Error> {
        if NetworkMonitor.shared.isConnected {
            return networkService.fetchLeagues(sportName: sportName)
                .handleEvents(receiveOutput: { [weak self] leagues in
                    self?.cacheLeagues(leagues, for: sportName)
                })
                .eraseToAnyPublisher()
        } else {
            do {
                let cachedLeagues = try localDataSource.fetchCachedLeagues(for: sportName)
                return Just(cachedLeagues)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            } catch {
                return Fail(error: error).eraseToAnyPublisher()
            }
        }
    }
    
    private func cacheLeagues(_ leagues: [League], for sportName: String) {
        do {
            try localDataSource.saveLeagues(leagues, for: sportName)
            print("Successfully cached \(leagues.count) leagues for \(sportName)")
        } catch {
            print("Failed to cache leagues for \(sportName): \(error.localizedDescription)")
        }
    }
}
