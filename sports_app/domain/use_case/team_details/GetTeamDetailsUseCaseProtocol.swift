//
//  GetTeamDetailsUseCaseProtocol.swift
//  sports_app
//

protocol GetTeamDetailsUseCaseProtocol {
    func execute(sport: String, teamId: Int, completion: @escaping (Result<[Team], Error>) -> Void)
}
