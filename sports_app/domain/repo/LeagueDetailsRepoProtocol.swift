//
//  LeagueDetailsRepoProtocol.swift
//  sports_app
//
//  Created by Thaowpsta Saiid on 30/05/2026.
//


protocol LeagueDetailsRepoProtocol {
    func fetchUpcomingEvents(leagueKey: Int, completion: @escaping (Result<[Event], Error>) -> Void)
    func fetchLatestResults(leagueKey: Int, completion: @escaping (Result<[Event], Error>) -> Void)
    func fetchTeams(leagueKey: Int, completion: @escaping (Result<[Team], Error>) -> Void)
}
