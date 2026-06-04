//
//  LeaguesRepository.swift
//  sports_app
//
//  Created by Thaowpsta Saiid on 23/05/2026.
//

import Alamofire
import Foundation

class LeaguesRepository: LeaguesRepoProtocol {

    private let networkService: LeaguesNetworkServiceProtocol

    init(networkService: LeaguesNetworkServiceProtocol = LeaguesNetworkService()) {
        self.networkService = networkService
    }

    func fetchLeagues(
        sportName: String,
        completion: @escaping (Result<[League], Error>) -> Void
    ) {
        networkService.fetchLeagues(sportName: sportName, completion: completion)
    }
}
