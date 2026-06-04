import Foundation
import Combine

class GetTeamsUseCase: GetTeamsUseCaseProtocol {
    private let repository: LeagueDetailsRepoProtocol
    init(repository: LeagueDetailsRepoProtocol) { self.repository = repository }
    
    func execute(leagueKey: Int) -> AnyPublisher<[Team], Error> {
        repository.fetchTeams(leagueKey: leagueKey)
    }
}
