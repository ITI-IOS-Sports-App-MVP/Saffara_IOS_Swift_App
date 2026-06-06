import Foundation
import Combine
@testable import sports_app

class MockLeaguesRepository: LeaguesRepoProtocol {
    var leaguesResult: Result<[League], Error>?
    func fetchLeagues(sportName: String) -> AnyPublisher<[League], Error> {
        if let result = leaguesResult {
            return result.publisher.eraseToAnyPublisher()
        }
        return Fail(error: NSError(domain: "test", code: -1, userInfo: nil)).eraseToAnyPublisher()
    }
}

class MockLeagueDetailsRepository: LeagueDetailsRepoProtocol {
    var upcomingEventsResult: Result<[Event], Error>?
    var latestResultsResult: Result<[Event], Error>?
    var teamsResult: Result<[Team], Error>?
    
    func fetchUpcomingEvents(leagueKey: Int) -> AnyPublisher<[Event], Error> {
        if let result = upcomingEventsResult {
            return result.publisher.eraseToAnyPublisher()
        }
        return Fail(error: NSError(domain: "test", code: -1, userInfo: nil)).eraseToAnyPublisher()
    }
    
    func fetchLatestResults(leagueKey: Int) -> AnyPublisher<[Event], Error> {
        if let result = latestResultsResult {
            return result.publisher.eraseToAnyPublisher()
        }
        return Fail(error: NSError(domain: "test", code: -1, userInfo: nil)).eraseToAnyPublisher()
    }
    
    func fetchTeams(leagueKey: Int) -> AnyPublisher<[Team], Error> {
        if let result = teamsResult {
            return result.publisher.eraseToAnyPublisher()
        }
        return Fail(error: NSError(domain: "test", code: -1, userInfo: nil)).eraseToAnyPublisher()
    }
}

class MockTeamDetailsRepository: TeamDetailsRepoProtocol {
    var teamDetailsResult: Result<[Team], Error>?
    func fetchTeamDetails(sport: String, teamId: Int) -> AnyPublisher<[Team], Error> {
        if let result = teamDetailsResult {
            return result.publisher.eraseToAnyPublisher()
        }
        return Fail(error: NSError(domain: "test", code: -1, userInfo: nil)).eraseToAnyPublisher()
    }
}

class MockUserRepository: UserRepoProtocol {
    var isFirstTime = true
    var language = "en"
    var isDarkTheme = false
    
    func readFirstEntry() -> Bool { return isFirstTime }
    func saveFirstEntry(_ isFirstEntry: Bool) { isFirstTime = isFirstEntry }
    
    func readLanguage() -> String { return language }
    func saveLanguage(_ languageCode: String) { language = languageCode }
    
    func readTheme() -> Bool { return isDarkTheme }
    func saveTheme(isDarkMode: Bool) { isDarkTheme = isDarkMode }
}
