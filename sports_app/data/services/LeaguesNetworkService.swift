//
//  LeaguesNetworkService.swift
//  sports_app
//

import Alamofire
import Foundation

class LeaguesNetworkService: LeaguesNetworkServiceProtocol {
    
    private let baseUrl = "https://apiv2.allsportsapi.com/"
    
    private var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    func fetchLeagues(sportName: String, completion: @escaping (Result<[League], Error>) -> Void) {
        let cleanSport = sportName.lowercased().trimmingCharacters(in: .whitespaces)
        let url = "\(baseUrl)\(cleanSport)/"
        let parameters: [String: Any] = [
            "met": "Leagues",
            "APIkey": APIKeyProvider.getApiKey()
        ]
        
        let standardDecoder = JSONDecoder()
        
        AF.request(url, parameters: parameters)
            .responseDecodable(of: AllSportsResponse<League>.self, decoder: standardDecoder) { response in
                switch response.result {
                case .success(let leaguesResponse):
                    if let leagues = leaguesResponse.result {
                        completion(.success(leagues))
                    } else {
                        let error = NSError(
                            domain: "LeaguesNetworkService",
                            code: -1,
                            userInfo: [NSLocalizedDescriptionKey: "No leagues found"]
                        )
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func fetchUpcomingEvents(sportName: String, leagueKey: Int, completion: @escaping (Result<[Event], Error>) -> Void) {
        let cleanSport = sportName.lowercased().trimmingCharacters(in: .whitespaces)
        let url = "\(baseUrl)\(cleanSport)/"
        
        let today = Date()
        let nextYear = Calendar.current.date(byAdding: .year, value: 1, to: today)!
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let fromDate = formatter.string(from: today)
        let toDate = formatter.string(from: nextYear)
        
        let parameters: [String: Any] = [
            "met": "Fixtures",
            "leagueId": leagueKey,
            "from": fromDate,
            "to": toDate,
            "APIkey": APIKeyProvider.getApiKey()
        ]
        
        AF.request(url, parameters: parameters)
            .responseDecodable(of: AllSportsResponse<Event>.self, decoder: decoder) { response in
                switch response.result {
                case .success(let eventsResponse):
                    completion(.success(eventsResponse.result ?? []))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func fetchLatestResults(sportName: String, leagueKey: Int, completion: @escaping (Result<[Event], Error>) -> Void) {
        let cleanSport = sportName.lowercased().trimmingCharacters(in: .whitespaces)
        let url = "\(baseUrl)\(cleanSport)/"
        
        let today = Date()
        let lastYear = Calendar.current.date(byAdding: .year, value: -1, to: today)!
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let fromDate = formatter.string(from: lastYear)
        let toDate = formatter.string(from: today)
        
        let parameters: [String: Any] = [
            "met": "Fixtures",
            "leagueId": leagueKey,
            "from": fromDate,
            "to": toDate,
            "APIkey": APIKeyProvider.getApiKey()
        ]
        
        AF.request(url, parameters: parameters)
            .responseDecodable(of: AllSportsResponse<Event>.self, decoder: decoder) { response in
                switch response.result {
                case .success(let eventsResponse):
                    completion(.success(eventsResponse.result ?? []))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
