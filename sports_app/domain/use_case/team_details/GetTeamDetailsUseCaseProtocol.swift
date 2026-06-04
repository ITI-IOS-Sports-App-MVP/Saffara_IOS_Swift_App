//
//  GetTeamDetailsUseCaseProtocol.swift
//  sports_app
//

import Foundation
import Combine

protocol GetTeamDetailsUseCaseProtocol {
    func execute(sport: String, teamId: Int) -> AnyPublisher<[Team], Error>
}
