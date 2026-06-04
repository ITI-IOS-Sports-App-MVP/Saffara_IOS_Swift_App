import Foundation
import Combine

protocol GetLeaguesUseCaseProtocol {
    func execute(sportName: String) -> AnyPublisher<[League], Error>
}