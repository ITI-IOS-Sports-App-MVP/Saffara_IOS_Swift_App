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
