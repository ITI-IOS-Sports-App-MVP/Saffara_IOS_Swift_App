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

    init(networkService: LeaguesNetworkServiceProtocol = LeaguesNetworkService()) {
        self.networkService = networkService
    }

    func fetchLeagues(
        sportName: String
    ) -> AnyPublisher<[League], Error> {
        networkService.fetchLeagues(sportName: sportName)
    }
}
