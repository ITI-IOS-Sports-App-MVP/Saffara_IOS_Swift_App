//
//  LeagueDetailsRepoProtocol.swift
//  sports_app
//
//  Created by Thaowpsta Saiid on 30/05/2026.
//


protocol LeagueDetailsRepoProtocol {
    func fetchUpcomingEvents(leagueId: Int, completion: @escaping (Result<[Event], Error>) -> Void)
    func fetchLatestResults(leagueId: Int, completion: @escaping (Result<[Event], Error>) -> Void)
    func fetchTeams(leagueId: Int, completion: @escaping (Result<[Team], Error>) -> Void)
}