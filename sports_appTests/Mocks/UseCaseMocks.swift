import Foundation
import Combine
@testable import sports_app

class MockGetLeaguesUseCase: GetLeaguesUseCaseProtocol {
    var result: Result<[League], Error>?
    
    func execute(sportName: String) -> AnyPublisher<[League], Error> {
        if let result = result {
            return result.publisher.eraseToAnyPublisher()
        }
        return Fail(error: NSError(domain: "test", code: -1, userInfo: nil)).eraseToAnyPublisher()
    }
}

class MockGetFavoritesUseCase: GetFavoritesUseCaseProtocol {
    var result: [League] = []
    var shouldThrowError = false
    
    func execute() throws -> [League] {
        if shouldThrowError {
            throw NSError(domain: "test", code: -1, userInfo: nil)
        }
        return result
    }
}

class MockRemoveFavoriteUseCase: RemoveFavoriteUseCaseProtocol {
    var shouldThrowError = false
    var removedLeagueKey: Int?
    
    func execute(leagueKey: Int) throws {
        if shouldThrowError {
            throw NSError(domain: "test", code: -1, userInfo: nil)
        }
        removedLeagueKey = leagueKey
    }
}

class MockAddFavoriteUseCase: AddFavoriteUseCaseProtocol {
    var shouldThrowError = false
    var addedLeague: League?
    
    func execute(league: League) throws {
        if shouldThrowError {
            throw NSError(domain: "test", code: -1, userInfo: nil)
        }
        addedLeague = league
    }
}

class MockReadThemeUseCase: ReadThemeUseCaseProtocol {
    var isDark = false
    func execute() -> Bool { return isDark }
}

class MockSaveThemeUseCase: SaveThemeUseCaseProtocol {
    var savedIsDark: Bool?
    func execute(isDarkMode: Bool) { savedIsDark = isDarkMode }
}

class MockReadLanguageUseCase: ReadLanguageUseCaseProtocol {
    var language = "en"
    func execute() -> String { return language }
}

class MockSaveLanguageUseCase: SaveLanguageUseCaseProtocol {
    var savedLanguage: String?
    func execute(languageCode: String) { savedLanguage = languageCode }
}

class MockSaveFirstEntryUseCase: SaveFirstEntryUseCaseProtocol {
    var savedIsFirstEntry: Bool?
    func execute(isFirstEntry: Bool) {
        savedIsFirstEntry = isFirstEntry
    }
}

class MockReadFirstEntryUseCase: ReadFirstEntryUseCaseProtocol {
    var isFirstEntry = true
    func execute() -> Bool {
        return isFirstEntry
    }
}

class MockNotificationService: NotificationServiceProtocol {
    var isAuthorized = true
    var requestAuthorizationCalled = false
    var scheduleNotificationCalled = false
    var scheduledTitle: String?
    var scheduledBody: String?
    var scheduledDate: Date?
    var scheduledIdentifier: String?
    
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        requestAuthorizationCalled = true
        completion(isAuthorized, nil)
    }
    
    func scheduleNotification(title: String, body: String, date: Date, identifier: String) {
        scheduleNotificationCalled = true
        scheduledTitle = title
        scheduledBody = body
        scheduledDate = date
        scheduledIdentifier = identifier
    }
}
