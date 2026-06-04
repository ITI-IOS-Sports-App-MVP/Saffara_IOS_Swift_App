import Foundation
@testable import sports_app

class MockCoreDataManager: CoreDataManagerProtocol {
    
    var leagues: [League] = []
    var shouldThrowError = false
    
    func fetchFavorites() throws -> [League] {
        if shouldThrowError {
            throw NSError(domain: "test", code: -1, userInfo: nil)
        }
        return leagues
    }
    
    func saveFavorite(league: League) throws {
        if shouldThrowError {
            throw NSError(domain: "test", code: -1, userInfo: nil)
        }
        if let key = league.leagueKey, !leagues.contains(where: { $0.leagueKey == key }) {
            leagues.append(league)
        }
    }
    
    func deleteFavorite(leagueKey: Int) throws {
        if shouldThrowError {
            throw NSError(domain: "test", code: -1, userInfo: nil)
        }
        leagues.removeAll { $0.leagueKey == leagueKey }
    }
}

class MockFavoriteLeaguesRepository: FavoriteLeaguesRepoProtocol {
    var leagues: [League] = []
    var shouldThrowError = false
    
    func getFavoriteLeagues() throws -> [League] {
        if shouldThrowError {
            throw NSError(domain: "test", code: -1, userInfo: nil)
        }
        return leagues
    }
    
    func addLeagueToFavorites(league: League) throws {
        if shouldThrowError {
            throw NSError(domain: "test", code: -1, userInfo: nil)
        }
        leagues.append(league)
    }
    
    func removeLeagueFromFavorites(leagueKey: Int) throws {
        if shouldThrowError {
            throw NSError(domain: "test", code: -1, userInfo: nil)
        }
        leagues.removeAll { $0.leagueKey == leagueKey }
    }
    
    func isFavorite(leagueKey: Int) -> Bool {
        return leagues.contains { $0.leagueKey == leagueKey }
    }
}
