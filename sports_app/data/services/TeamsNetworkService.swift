//
//  TeamsNetworkService.swift
//  sports_app
//

import Alamofire
import Foundation
import Combine

class TeamsNetworkService: TeamsNetworkServiceProtocol {
    
    private let baseUrl = "https://apiv2.allsportsapi.com/"
    
    private var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    func fetchTeams(sportName: String, leagueKey: Int) -> AnyPublisher<[Team], Error> {
        Future { [weak self] promise in
            guard let self = self else { return }
            let cleanSport = sportName.lowercased().trimmingCharacters(in: .whitespaces)
            let url = "\(self.baseUrl)\(cleanSport)/"
            
            let parameters: [String: Any] = [
                "met": "Teams",
                "leagueId": leagueKey,
                "APIkey": APIKeyProvider.getApiKey()
            ]
            
            AF.request(url, parameters: parameters)
                .responseDecodable(of: AllSportsResponse<Team>.self, decoder: self.decoder) { response in
                    switch response.result {
                    case .success(let teamsResponse):
                        promise(.success(teamsResponse.result ?? []))
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    func fetchTeamDetails(sportName: String, teamId: Int) -> AnyPublisher<[Team], Error> {
        Future { [weak self] promise in
            guard let self = self else { return }
            let cleanSport = sportName.lowercased().trimmingCharacters(in: .whitespaces)
            let url = "\(self.baseUrl)\(cleanSport)/"
            
            let parameters: [String: Any] = [
                "met": "Teams",
                "teamId": teamId,
                "APIkey": APIKeyProvider.getApiKey()
            ]
            
            AF.request(url, parameters: parameters)
                .responseDecodable(of: AllSportsResponse<Team>.self, decoder: self.decoder) { response in
                    switch response.result {
                    case .success(let teamsResponse):
                        promise(.success(teamsResponse.result ?? []))
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
}
