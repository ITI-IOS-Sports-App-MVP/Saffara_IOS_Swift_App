import Foundation
import Combine

protocol LeaguesRepoProtocol {
    func fetchLeagues(sportName: String) -> AnyPublisher<[League], Error>
}