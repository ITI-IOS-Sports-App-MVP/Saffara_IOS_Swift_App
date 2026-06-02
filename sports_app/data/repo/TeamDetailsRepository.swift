//
//  TeamDetailsRepository.swift
//  sports_app
//

import Foundation

class TeamDetailsRepository: TeamDetailsRepoProtocol {
    
    private func getApiKey() -> String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else {
            print("⚠️ API_KEY not found in Info.plist")
            return ""
        }
        return key
    }
    
    func fetchTeamDetails(sport: String, teamId: Int, completion: @escaping (Result<[Team], Error>) -> Void) {
        let cleanSport = sport.lowercased().trimmingCharacters(in: .whitespaces)
        let urlString = "https://apiv2.allsportsapi.com/\(cleanSport)/?met=Teams&teamId=\(teamId)&APIkey=\(getApiKey())"
        
        guard let url = URL(string: urlString) else {
            let error = NSError(
                domain: "Invalid URL",
                code: 400,
                userInfo: [NSLocalizedDescriptionKey: "Failed to construct URL"]
            )
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }
            
            guard let data = data else {
                let error = NSError(
                    domain: "No Data",
                    code: 404,
                    userInfo: [NSLocalizedDescriptionKey: "No data received from server."]
                )
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let decodedResponse = try decoder.decode(AllSportsResponse<Team>.self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(decodedResponse.result ?? []))
                }
            } catch {
                DispatchQueue.main.async {
                    print("Decoding Error: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
