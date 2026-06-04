import Foundation
import Combine

protocol GetUpcomingEventsUseCaseProtocol {
    func execute(leagueKey: Int) -> AnyPublisher<[Event], Error>
}
