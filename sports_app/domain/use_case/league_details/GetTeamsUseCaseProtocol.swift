//
//  GetTeamsUseCaseProtocol.swift
//  sports_app
//
//  Created by Thaowpsta Saiid on 30/05/2026.
//

import Foundation

protocol GetTeamsUseCaseProtocol {
    func execute(leagueId: Int, completion: @escaping (Result<[Team], Error>) -> Void)
}


