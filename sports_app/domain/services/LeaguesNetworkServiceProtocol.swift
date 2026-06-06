//
//  LeaguesNetworkServiceProtocol.swift
//  sports_app
//

import Foundation
import Combine

protocol LeaguesNetworkServiceProtocol {
    func fetchLeagues(sportName: String) -> AnyPublisher<[League], Error>
    func fetchUpcomingEvents(sportName: String, leagueKey: Int) -> AnyPublisher<[Event], Error>
    func fetchLatestResults(sportName: String, leagueKey: Int) -> AnyPublisher<[Event], Error>
}
