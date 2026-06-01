//
//  GetLeaguesUseCaseProtocol.swift
//  sports_app
//
//  Created by Thaowpsta Saiid on 23/05/2026.
//


protocol GetLeaguesUseCaseProtocol {
    func execute(sportName: String, completion: @escaping (Result<[League], Error>) -> Void)
}