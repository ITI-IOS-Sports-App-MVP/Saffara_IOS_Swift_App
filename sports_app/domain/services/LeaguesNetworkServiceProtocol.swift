//
//  LeaguesNetworkServiceProtocol.swift
//  sports_app
//

import Foundation

protocol LeaguesNetworkServiceProtocol {
    func fetchLeagues(sportName: String, completion: @escaping (Result<[League], Error>) -> Void)
    func fetchUpcomingEvents(sportName: String, leagueKey: Int, completion: @escaping (Result<[Event], Error>) -> Void)
    func fetchLatestResults(sportName: String, leagueKey: Int, completion: @escaping (Result<[Event], Error>) -> Void)
}
