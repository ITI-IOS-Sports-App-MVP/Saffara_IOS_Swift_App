//
//  TeamsNetworkService.swift
//  sports_app
//

import Alamofire
import Foundation

class TeamsNetworkService: TeamsNetworkServiceProtocol {
    
    private let baseUrl = "https://apiv2.allsportsapi.com/"
    
    private var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    func fetchTeams(sportName: String, leagueKey: Int, completion: @escaping (Result<[Team], Error>) -> Void) {
        let cleanSport = sportName.lowercased().trimmingCharacters(in: .whitespaces)
        let url = "\(baseUrl)\(cleanSport)/"
        
        let parameters: [String: Any] = [
            "met": "Teams",
            "leagueId": leagueKey,
            "APIkey": APIKeyProvider.getApiKey()
        ]
        
        AF.request(url, parameters: parameters)
            .responseDecodable(of: AllSportsResponse<Team>.self, decoder: decoder) { response in
                switch response.result {
                case .success(let teamsResponse):
                    completion(.success(teamsResponse.result ?? []))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func fetchTeamDetails(sportName: String, teamId: Int, completion: @escaping (Result<[Team], Error>) -> Void) {
        let cleanSport = sportName.lowercased().trimmingCharacters(in: .whitespaces)
        let url = "\(baseUrl)\(cleanSport)/"
        
        let parameters: [String: Any] = [
            "met": "Teams",
            "teamId": teamId,
            "APIkey": APIKeyProvider.getApiKey()
        ]
        
        AF.request(url, parameters: parameters)
            .responseDecodable(of: AllSportsResponse<Team>.self, decoder: decoder) { response in
                switch response.result {
                case .success(let teamsResponse):
                    completion(.success(teamsResponse.result ?? []))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
