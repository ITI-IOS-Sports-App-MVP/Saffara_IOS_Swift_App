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

    var cachedLeagues: [String: [League]] = [:]
    var cachedTeams: [Int: [Team]] = [:]
    var cachedEvents: [String: [Event]] = [:] // key: "\(leagueKey)_\(type)"

    func fetchCachedLeagues(for sportName: String) throws -> [League] {
        if shouldThrowError { throw NSError(domain: "test", code: -1, userInfo: nil) }
        return cachedLeagues[sportName] ?? []
    }
    
    func saveLeagues(_ leagues: [League], for sportName: String) throws {
        if shouldThrowError { throw NSError(domain: "test", code: -1, userInfo: nil) }
        cachedLeagues[sportName] = leagues
    }
    
    func saveTeams(_ teams: [Team], for leagueKey: Int) throws {
        if shouldThrowError { throw NSError(domain: "test", code: -1, userInfo: nil) }
        cachedTeams[leagueKey] = teams
    }
    
    func fetchCachedTeams(for leagueKey: Int) throws -> [Team] {
        if shouldThrowError { throw NSError(domain: "test", code: -1, userInfo: nil) }
        return cachedTeams[leagueKey] ?? []
    }

    func saveEvents(_ events: [Event], for leagueKey: Int, type: String) throws {
        if shouldThrowError { throw NSError(domain: "test", code: -1, userInfo: nil) }
        cachedEvents["\(leagueKey)_\(type)"] = events
    }
    
    func fetchCachedEvents(for leagueKey: Int, type: String) throws -> [Event] {
        if shouldThrowError { throw NSError(domain: "test", code: -1, userInfo: nil) }
        return cachedEvents["\(leagueKey)_\(type)"] ?? []
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
