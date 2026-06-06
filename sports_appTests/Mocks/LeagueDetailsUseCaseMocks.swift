import Foundation
import Combine
@testable import sports_app

class MockGetUpcomingEventsUseCase: GetUpcomingEventsUseCaseProtocol {
    var result: Result<[Event], Error>?
    
    func execute(leagueKey: Int) -> AnyPublisher<[Event], Error> {
        if let result = result {
            return result.publisher.eraseToAnyPublisher()
        }
        return Fail(error: NSError(domain: "test", code: -1, userInfo: nil)).eraseToAnyPublisher()
    }
}

class MockGetLatestResultsUseCase: GetLatestResultsUseCaseProtocol {
    var result: Result<[Event], Error>?
    
    func execute(leagueKey: Int) -> AnyPublisher<[Event], Error> {
        if let result = result {
            return result.publisher.eraseToAnyPublisher()
        }
        return Fail(error: NSError(domain: "test", code: -1, userInfo: nil)).eraseToAnyPublisher()
    }
}

class MockGetTeamsUseCase: GetTeamsUseCaseProtocol {
    var result: Result<[Team], Error>?
    
    func execute(leagueKey: Int) -> AnyPublisher<[Team], Error> {
        if let result = result {
            return result.publisher.eraseToAnyPublisher()
        }
        return Fail(error: NSError(domain: "test", code: -1, userInfo: nil)).eraseToAnyPublisher()
    }
}

class MockScheduleAlertUseCase: ScheduleAlertUseCaseProtocol {
    var executedSportName: String?
    var executedEventName: String?
    var executedDate: Date?
    
    func execute(sportName: String, eventName: String, date: Date) {
        executedSportName = sportName
        executedEventName = eventName
        executedDate = date
    }
}
