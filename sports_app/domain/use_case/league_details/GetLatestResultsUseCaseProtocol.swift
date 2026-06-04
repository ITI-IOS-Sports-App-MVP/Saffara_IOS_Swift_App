import Foundation
import Combine

protocol GetLatestResultsUseCaseProtocol {
    func execute(leagueKey: Int) -> AnyPublisher<[Event], Error>
}

