import Foundation
import Combine

protocol LeagueDetailsRepoProtocol {
    func fetchUpcomingEvents(leagueKey: Int) -> AnyPublisher<[Event], Error>
    func fetchLatestResults(leagueKey: Int) -> AnyPublisher<[Event], Error>
    func fetchTeams(leagueKey: Int) -> AnyPublisher<[Team], Error>
}
