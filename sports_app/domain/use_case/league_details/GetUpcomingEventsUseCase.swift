import Foundation
import Combine

class GetUpcomingEventsUseCase: GetUpcomingEventsUseCaseProtocol {
    private let repository: LeagueDetailsRepoProtocol
    
    init(repository: LeagueDetailsRepoProtocol) { self.repository = repository }
    
    func execute(leagueKey: Int) -> AnyPublisher<[Event], Error> {
        repository.fetchUpcomingEvents(leagueKey: leagueKey)
    }
}
