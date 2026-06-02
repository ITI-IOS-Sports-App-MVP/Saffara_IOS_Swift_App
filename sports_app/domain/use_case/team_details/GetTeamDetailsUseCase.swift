//
//  GetTeamDetailsUseCase.swift
//  sports_app
//

class GetTeamDetailsUseCase: GetTeamDetailsUseCaseProtocol {
    private let repository: TeamDetailsRepoProtocol
    
    init(repository: TeamDetailsRepoProtocol) {
        self.repository = repository
    }
    
    func execute(sport: String, teamId: Int, completion: @escaping (Result<[Team], Error>) -> Void) {
        repository.fetchTeamDetails(sport: sport, teamId: teamId, completion: completion)
    }
}
