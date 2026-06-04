import Foundation
import Combine

protocol GetTeamsUseCaseProtocol {
    func execute(leagueKey: Int) -> AnyPublisher<[Team], Error>
}


