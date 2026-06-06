import Foundation
import Combine
@testable import sports_app

class MockLeaguesNetworkService: LeaguesNetworkServiceProtocol {
    
    var fetchLeaguesResult: Result<[League], Error>?
    var fetchUpcomingEventsResult: Result<[Event], Error>?
    var fetchLatestResultsResult: Result<[Event], Error>?
    
    func fetchLeagues(sportName: String) -> AnyPublisher<[League], Error> {
        if let result = fetchLeaguesResult {
            return result.publisher.eraseToAnyPublisher()
        }
        return Fail(error: NSError(domain: "test", code: -1, userInfo: nil)).eraseToAnyPublisher()
    }
    
    func fetchUpcomingEvents(sportName: String, leagueKey: Int) -> AnyPublisher<[Event], Error> {
        if let result = fetchUpcomingEventsResult {
            return result.publisher.eraseToAnyPublisher()
        }
        return Fail(error: NSError(domain: "test", code: -1, userInfo: nil)).eraseToAnyPublisher()
    }
    
    func fetchLatestResults(sportName: String, leagueKey: Int) -> AnyPublisher<[Event], Error> {
        if let result = fetchLatestResultsResult {
            return result.publisher.eraseToAnyPublisher()
        }
        return Fail(error: NSError(domain: "test", code: -1, userInfo: nil)).eraseToAnyPublisher()
    }
}

class MockTeamsNetworkService: TeamsNetworkServiceProtocol {
    
    var fetchTeamsResult: Result<[Team], Error>?
    var fetchTeamDetailsResult: Result<[Team], Error>?
    
    func fetchTeams(sportName: String, leagueKey: Int) -> AnyPublisher<[Team], Error> {
        if let result = fetchTeamsResult {
            return result.publisher.eraseToAnyPublisher()
        }
        return Fail(error: NSError(domain: "test", code: -1, userInfo: nil)).eraseToAnyPublisher()
    }
    
    func fetchTeamDetails(sportName: String, teamId: Int) -> AnyPublisher<[Team], Error> {
        if let result = fetchTeamDetailsResult {
            return result.publisher.eraseToAnyPublisher()
        }
        return Fail(error: NSError(domain: "test", code: -1, userInfo: nil)).eraseToAnyPublisher()
    }
}
