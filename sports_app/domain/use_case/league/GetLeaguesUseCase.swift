import Foundation
import Combine

class GetLeaguesUseCase: GetLeaguesUseCaseProtocol {
    private let repository: LeaguesRepoProtocol
    
    init(repository: LeaguesRepoProtocol) {
        self.repository = repository
    }
    
    func execute(sportName: String) -> AnyPublisher<[League], Error> {
        repository.fetchLeagues(sportName: sportName)
    }
}