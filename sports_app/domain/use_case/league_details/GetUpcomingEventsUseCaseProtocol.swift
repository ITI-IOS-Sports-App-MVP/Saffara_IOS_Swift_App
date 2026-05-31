//
//  GetUpcomingEventsUseCaseProtocol.swift
//  sports_app
//
//  Created by Thaowpsta Saiid on 30/05/2026.
//


protocol GetUpcomingEventsUseCaseProtocol {
    func execute(leagueKey: Int, completion: @escaping (Result<[Event], Error>) -> Void)
}
