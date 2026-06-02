//
//  TeamDetailsRepoProtocol.swift
//  sports_app
//

protocol TeamDetailsRepoProtocol {
    func fetchTeamDetails(sport: String, teamId: Int, completion: @escaping (Result<[Team], Error>) -> Void)
}
