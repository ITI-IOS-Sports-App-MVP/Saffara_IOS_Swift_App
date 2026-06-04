import XCTest
@testable import sports_app

final class FavoriteLeaguesRepositoryTests: XCTestCase {
    var sut: FavoriteLeaguesRepository!
    var mockCoreDataManager: MockCoreDataManager!

    override func setUpWithError() throws {
        mockCoreDataManager = MockCoreDataManager()
        sut = FavoriteLeaguesRepository(localDataSource: mockCoreDataManager)
    }

    override func tearDownWithError() throws {
        sut = nil
        mockCoreDataManager = nil
    }

    func testGetFavoriteLeagues_Success() throws {
        // Arrange
        let league1 = League(leagueKey: 1, leagueName: "Test1", leagueLogo: nil, leagueCountry: nil, sportName: "football")
        let league2 = League(leagueKey: 2, leagueName: "Test2", leagueLogo: nil, leagueCountry: nil, sportName: "football")
        mockCoreDataManager.leagues = [league1, league2]

        // Act
        let fetched = try sut.getFavoriteLeagues()

        // Assert
        XCTAssertEqual(fetched.count, 2)
        XCTAssertEqual(fetched.first?.leagueKey, 1)
    }

    func testGetFavoriteLeagues_Failure() throws {
        // Arrange
        mockCoreDataManager.shouldThrowError = true

        // Act & Assert
        XCTAssertThrowsError(try sut.getFavoriteLeagues())
    }

    func testAddLeagueToFavorites_Success() throws {
        // Arrange
        let league = League(leagueKey: 3, leagueName: "Test3", leagueLogo: nil, leagueCountry: nil, sportName: "tennis")

        // Act
        try sut.addLeagueToFavorites(league: league)

        // Assert
        XCTAssertEqual(mockCoreDataManager.leagues.count, 1)
        XCTAssertEqual(mockCoreDataManager.leagues.first?.leagueKey, 3)
    }

    func testRemoveLeagueFromFavorites_Success() throws {
        // Arrange
        let league = League(leagueKey: 4, leagueName: "Test4", leagueLogo: nil, leagueCountry: nil, sportName: "football")
        mockCoreDataManager.leagues = [league]

        // Act
        try sut.removeLeagueFromFavorites(leagueKey: 4)

        // Assert
        XCTAssertTrue(mockCoreDataManager.leagues.isEmpty)
    }

    func testIsFavorite_WhenFavoriteExists_ReturnsTrue() throws {
        // Arrange
        let league = League(leagueKey: 5, leagueName: "Test5", leagueLogo: nil, leagueCountry: nil, sportName: "basketball")
        mockCoreDataManager.leagues = [league]

        // Act
        let isFav = sut.isFavorite(leagueKey: 5)

        // Assert
        XCTAssertTrue(isFav)
    }

    func testIsFavorite_WhenFavoriteDoesNotExist_ReturnsFalse() throws {
        // Arrange
        let league = League(leagueKey: 6, leagueName: "Test6", leagueLogo: nil, leagueCountry: nil, sportName: "basketball")
        mockCoreDataManager.leagues = [league]

        // Act
        let isFav = sut.isFavorite(leagueKey: 99)

        // Assert
        XCTAssertFalse(isFav)
    }

    func testIsFavorite_WhenFetchFails_ReturnsFalse() throws {
        // Arrange
        mockCoreDataManager.shouldThrowError = true

        // Act
        let isFav = sut.isFavorite(leagueKey: 5)

        // Assert
        XCTAssertFalse(isFav)
    }
}
