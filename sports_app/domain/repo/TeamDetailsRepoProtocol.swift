//
//  TeamDetailsRepoProtocol.swift
//  sports_app
//

import Foundation
import Combine

protocol TeamDetailsRepoProtocol {
    func fetchTeamDetails(sport: String, teamId: Int) -> AnyPublisher<[Team], Error>
}
