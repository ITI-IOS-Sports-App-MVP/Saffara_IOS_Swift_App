import XCTest
import Combine
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

final class LeaguesRepositoryTests: XCTestCase {
    var sut: LeaguesRepository!
    var mockNetwork: MockLeaguesNetworkService!
    var mockLocal: MockCoreDataManager!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockNetwork = MockLeaguesNetworkService()
        mockLocal = MockCoreDataManager()
        sut = LeaguesRepository(networkService: mockNetwork, localDataSource: mockLocal)
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        mockNetwork = nil
        mockLocal = nil
        cancellables = nil
        NetworkMonitor.shared.mockIsConnected = nil
        super.tearDown()
    }
    
    func testFetchLeagues_WhenOnline_FetchesFromNetworkAndCaches() {
        NetworkMonitor.shared.mockIsConnected = true
        let league = League(leagueKey: 1, leagueName: "Test", leagueLogo: nil, leagueCountry: nil, sportName: "football")
        mockNetwork.fetchLeaguesResult = .success([league])
        
        let expectation = XCTestExpectation(description: "Fetch leagues online")
        sut.fetchLeagues(sportName: "football")
            .sink(receiveCompletion: { _ in }, receiveValue: { leagues in
                XCTAssertEqual(leagues.count, 1)
                XCTAssertEqual(leagues.first?.leagueKey, 1)
                XCTAssertEqual(self.mockLocal.cachedLeagues["football"]?.count, 1)
                expectation.fulfill()
            })
            .store(in: &cancellables)
            
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchLeagues_WhenOffline_FetchesFromCache() {
        NetworkMonitor.shared.mockIsConnected = false
        let league = League(leagueKey: 1, leagueName: "Cached Test", leagueLogo: nil, leagueCountry: nil, sportName: "football")
        mockLocal.cachedLeagues["football"] = [league]
        
        let expectation = XCTestExpectation(description: "Fetch leagues offline")
        sut.fetchLeagues(sportName: "football")
            .sink(receiveCompletion: { _ in }, receiveValue: { leagues in
                XCTAssertEqual(leagues.count, 1)
                XCTAssertEqual(leagues.first?.leagueName, "Cached Test")
                expectation.fulfill()
            })
            .store(in: &cancellables)
            
        wait(for: [expectation], timeout: 1.0)
    }
}

final class LeagueDetailsRepositoryTests: XCTestCase {
    var sut: LeagueDetailsRepository!
    var mockLeaguesNetwork: MockLeaguesNetworkService!
    var mockTeamsNetwork: MockTeamsNetworkService!
    var mockLocal: MockCoreDataManager!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockLeaguesNetwork = MockLeaguesNetworkService()
        mockTeamsNetwork = MockTeamsNetworkService()
        mockLocal = MockCoreDataManager()
        sut = LeagueDetailsRepository(sport: "football", leaguesNetworkService: mockLeaguesNetwork, teamsNetworkService: mockTeamsNetwork, localDataSource: mockLocal)
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        mockLeaguesNetwork = nil
        mockTeamsNetwork = nil
        mockLocal = nil
        cancellables = nil
        NetworkMonitor.shared.mockIsConnected = nil
        super.tearDown()
    }
    
    func testFetchUpcomingEvents_WhenOnline_FetchesAndCaches() {
        NetworkMonitor.shared.mockIsConnected = true
        let event = Event(eventKey: 1, eventDate: nil, eventTime: nil, eventHomeTeam: nil, eventAwayTeam: nil, homeTeamLogo: nil, awayTeamLogo: nil, eventHomeTeamLogo: nil, eventAwayTeamLogo: nil, eventFirstPlayer: nil, eventSecondPlayer: nil, eventFirstPlayerLogo: nil, eventSecondPlayerLogo: nil, eventHomePlayer: nil, eventAwayPlayer: nil, eventFinalResult: nil, eventDateStart: nil, eventHomeFinalResult: nil, eventAwayFinalResult: nil)
        mockLeaguesNetwork.fetchUpcomingEventsResult = .success([event])
        
        let expectation = XCTestExpectation(description: "Fetch upcoming online")
        sut.fetchUpcomingEvents(leagueKey: 5)
            .sink(receiveCompletion: { _ in }, receiveValue: { events in
                XCTAssertEqual(events.count, 1)
                XCTAssertEqual(self.mockLocal.cachedEvents["5_upcoming"]?.count, 1)
                expectation.fulfill()
            })
            .store(in: &cancellables)
            
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchUpcomingEvents_WhenOffline_ReadsFromCache() {
        NetworkMonitor.shared.mockIsConnected = false
        let event = Event(eventKey: 2, eventDate: nil, eventTime: nil, eventHomeTeam: nil, eventAwayTeam: nil, homeTeamLogo: nil, awayTeamLogo: nil, eventHomeTeamLogo: nil, eventAwayTeamLogo: nil, eventFirstPlayer: nil, eventSecondPlayer: nil, eventFirstPlayerLogo: nil, eventSecondPlayerLogo: nil, eventHomePlayer: nil, eventAwayPlayer: nil, eventFinalResult: nil, eventDateStart: nil, eventHomeFinalResult: nil, eventAwayFinalResult: nil)
        mockLocal.cachedEvents["5_upcoming"] = [event]
        
        let expectation = XCTestExpectation(description: "Fetch upcoming offline")
        sut.fetchUpcomingEvents(leagueKey: 5)
            .sink(receiveCompletion: { _ in }, receiveValue: { events in
                XCTAssertEqual(events.count, 1)
                XCTAssertEqual(events.first?.eventKey, 2)
                expectation.fulfill()
            })
            .store(in: &cancellables)
            
        wait(for: [expectation], timeout: 1.0)
    }
}
