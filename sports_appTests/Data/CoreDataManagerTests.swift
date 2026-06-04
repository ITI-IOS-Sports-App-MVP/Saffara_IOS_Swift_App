import XCTest
@testable import sports_app

final class CoreDataManagerTests: XCTestCase {
    var sut: CoreDataManager!

    override func setUpWithError() throws {
        sut = CoreDataManager.shared
    }

    override func tearDownWithError() throws {
        // Clean up any inserted mock data
        let leagues = try sut.fetchFavorites()
        for league in leagues {
            if let key = league.leagueKey, key >= 999000 { // Assume we use high IDs for tests
                try sut.deleteFavorite(leagueKey: key)
            }
        }
    }

    func testSaveAndFetchFavorite() throws {
        // Arrange
        let testLeagueKey = 999001
        let league = League(leagueKey: testLeagueKey, leagueName: "Test CoreData League", leagueLogo: "logo.png", leagueCountry: "Test Country", sportName: "football")

        // Act
        try sut.saveFavorite(league: league)
        let fetched = try sut.fetchFavorites()

        // Assert
        XCTAssertTrue(fetched.contains(where: { $0.leagueKey == testLeagueKey }), "Saved league should be fetched from CoreData")
    }

    func testDeleteFavorite() throws {
        // Arrange
        let testLeagueKey = 999002
        let league = League(leagueKey: testLeagueKey, leagueName: "Test CoreData League 2", leagueLogo: "logo2.png", leagueCountry: "Test Country 2", sportName: "basketball")
        try sut.saveFavorite(league: league)

        // Verify it was added
        var fetched = try sut.fetchFavorites()
        XCTAssertTrue(fetched.contains(where: { $0.leagueKey == testLeagueKey }))

        // Act
        try sut.deleteFavorite(leagueKey: testLeagueKey)

        // Assert
        fetched = try sut.fetchFavorites()
        XCTAssertFalse(fetched.contains(where: { $0.leagueKey == testLeagueKey }), "Deleted league should not be in CoreData")
    }
}
