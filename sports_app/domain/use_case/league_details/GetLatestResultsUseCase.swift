import Foundation
import Combine

class GetLatestResultsUseCase: GetLatestResultsUseCaseProtocol {
    private let repository: LeagueDetailsRepoProtocol
    init(repository: LeagueDetailsRepoProtocol) { self.repository = repository }
    
    func execute(leagueKey: Int) -> AnyPublisher<[Event], Error> {
        repository.fetchLatestResults(leagueKey: leagueKey)
    }
}
