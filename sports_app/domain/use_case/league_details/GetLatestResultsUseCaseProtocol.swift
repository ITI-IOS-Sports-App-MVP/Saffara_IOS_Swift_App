//
//  GetLatestResultsUseCaseProtocol.swift
//  sports_app
//
//  Created by Thaowpsta Saiid on 30/05/2026.
//


protocol GetLatestResultsUseCaseProtocol {
    func execute(leagueKey: Int, completion: @escaping (Result<[Event], Error>) -> Void)
}

