//
//  AllSportsResponse.swift
//  sports_app
//
//  Created by Thaowpsta Saiid on 30/05/2026.
//

import Foundation

struct AllSportsResponse<T: Codable>: Codable {
    let success: Int?
    let result: [T]?
}

class LeagueDetailsRepository: LeagueDetailsRepoProtocol {

    private let baseUrl: String

    init(sport: String) {
        let sport = sport.lowercased().trimmingCharacters(
            in: .whitespaces
        )
        self.baseUrl = "https://apiv2.allsportsapi.com/\(sport)/"
    }

    private func getApiKey() -> String {
        guard
            let key = Bundle.main.object(forInfoDictionaryKey: "API_KEY")
                as? String
        else {
            print("⚠️ API_KEY not found in Info.plist")
            return ""
        }
        return key
    }

    func fetchUpcomingEvents(
        leagueKey: Int,
        completion: @escaping (Result<[Event], Error>) -> Void
    ) {
        let today = Date()
        let nextYear = Calendar.current.date(
            byAdding: .year,
            value: 1,
            to: today
        )!

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let fromDate = formatter.string(from: today)
        let toDate = formatter.string(from: nextYear)

        let urlString =
            "\(baseUrl)?met=Fixtures&leagueId=\(leagueKey)&from=\(fromDate)&to=\(toDate)&APIkey=\(getApiKey())"

        fetchData(from: urlString, completion: completion)
    }

    func fetchLatestResults(
        leagueKey: Int,
        completion: @escaping (Result<[Event], Error>) -> Void
    ) {
        let today = Date()
        let lastYear = Calendar.current.date(
            byAdding: .year,
            value: -1,
            to: today
        )!

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let fromDate = formatter.string(from: lastYear)
        let toDate = formatter.string(from: today)

        let urlString =
            "\(baseUrl)?met=Fixtures&leagueId=\(leagueKey)&from=\(fromDate)&to=\(toDate)&APIkey=\(getApiKey())"

        fetchData(from: urlString, completion: completion)
    }

    func fetchTeams(
        leagueKey: Int,
        completion: @escaping (Result<[Team], Error>) -> Void
    ) {
        let urlString =
            "\(baseUrl)?met=Teams&leagueId=\(leagueKey)&APIkey=\(getApiKey())"

        fetchData(from: urlString, completion: completion)
    }

    private func fetchData<T: Codable>(
        from urlString: String,
        completion: @escaping (Result<[T], Error>) -> Void
    ) {

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
                    userInfo: [
                        NSLocalizedDescriptionKey:
                            "No data received from server."
                    ]
                )
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase

                let decodedResponse = try decoder.decode(
                    AllSportsResponse<T>.self,
                    from: data
                )

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
