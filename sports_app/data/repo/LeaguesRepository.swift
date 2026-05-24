//
//  LeaguesRepository.swift
//  sports_app
//
//  Created by Thaowpsta Saiid on 23/05/2026.
//


import Foundation
import Alamofire

class LeaguesRepository: LeaguesRepoProtocol {

    
    func getApiKey() -> String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else {
            fatalError("API_KEY not found in Info.plist")
        }
        return key
    }
    
    func fetchLeagues(sportName: String, completion: @escaping (Result<[League], Error>) -> Void) {
        let url = "https://apiv2.allsportsapi.com/\(sportName)/"
        let parameters: [String: Any] = [
            "met": "Leagues",
            "APIkey": getApiKey()
        ]
        
        AF.request(url, parameters: parameters).responseDecodable(of: LeaguesResponse.self) { response in
            switch response.result {
            case .success(let leaguesResponse):
                print("Successfully decoded \(leaguesResponse.result?.count ?? 0) leagues")
                if let leagues = leaguesResponse.result {
                    completion(.success(leagues))
                } else {
                    let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data found"])
                    completion(.failure(error))
                }
            case .failure(let error):
                print("Decoding Error: \(error)")
                completion(.failure(error))
            }
        }
    }
}
