import XCTest
import Combine
@testable import sports_app

final class UseCaseTests: XCTestCase {
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = []
    }
    
    override func tearDown() {
        cancellables = nil
        super.tearDown()
    }
    
    func testGetLeaguesUseCase() {
        let mockRepo = MockLeaguesRepository()
        let useCase = GetLeaguesUseCase(repository: mockRepo)
        let expectedLeagues = [League(leagueKey: 1, leagueName: "La Liga", leagueLogo: nil, leagueCountry: nil, sportName: "football")]
        mockRepo.leaguesResult = .success(expectedLeagues)
        
        let expectation = XCTestExpectation(description: "Get leagues success")
        useCase.execute(sportName: "football")
            .sink(receiveCompletion: { _ in }, receiveValue: { leagues in
                XCTAssertEqual(leagues.count, 1)
                XCTAssertEqual(leagues.first?.leagueName, "La Liga")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testGetFavoritesUseCase_And_AddFavoriteUseCase_And_RemoveFavoriteUseCase() throws {
        let mockRepo = MockFavoriteLeaguesRepository()
        let addUseCase = AddFavoriteUseCase(repository: mockRepo)
        let removeUseCase = RemoveFavoriteUseCase(repository: mockRepo)
        let getUseCase = GetFavoritesUseCase(repository: mockRepo)
        
        let league = League(leagueKey: 123, leagueName: "Premier League", leagueLogo: nil, leagueCountry: nil, sportName: "football")
        
        // Save
        try addUseCase.execute(league: league)
        XCTAssertTrue(mockRepo.isFavorite(leagueKey: 123))
        
        // Get
        let favorites = try getUseCase.execute()
        XCTAssertEqual(favorites.count, 1)
        XCTAssertEqual(favorites.first?.leagueKey, 123)
        
        // Remove
        try removeUseCase.execute(leagueKey: 123)
        XCTAssertFalse(mockRepo.isFavorite(leagueKey: 123))
    }
    
    func testGetUpcomingEventsUseCase() {
        let mockRepo = MockLeagueDetailsRepository()
        let useCase = GetUpcomingEventsUseCase(repository: mockRepo)
        let event = Event(eventKey: 10, eventDate: "2026-06-06", eventTime: nil, eventHomeTeam: "A", eventAwayTeam: "B", homeTeamLogo: nil, awayTeamLogo: nil, eventHomeTeamLogo: nil, eventAwayTeamLogo: nil, eventFirstPlayer: nil, eventSecondPlayer: nil, eventFirstPlayerLogo: nil, eventSecondPlayerLogo: nil, eventHomePlayer: nil, eventAwayPlayer: nil, eventFinalResult: nil, eventDateStart: nil, eventHomeFinalResult: nil, eventAwayFinalResult: nil)
        mockRepo.upcomingEventsResult = .success([event])
        
        let expectation = XCTestExpectation(description: "Get upcoming events")
        useCase.execute(leagueKey: 5)
            .sink(receiveCompletion: { _ in }, receiveValue: { events in
                XCTAssertEqual(events.count, 1)
                XCTAssertEqual(events.first?.eventKey, 10)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testGetLatestResultsUseCase() {
        let mockRepo = MockLeagueDetailsRepository()
        let useCase = GetLatestResultsUseCase(repository: mockRepo)
        let event = Event(eventKey: 11, eventDate: "2026-06-06", eventTime: nil, eventHomeTeam: "C", eventAwayTeam: "D", homeTeamLogo: nil, awayTeamLogo: nil, eventHomeTeamLogo: nil, eventAwayTeamLogo: nil, eventFirstPlayer: nil, eventSecondPlayer: nil, eventFirstPlayerLogo: nil, eventSecondPlayerLogo: nil, eventHomePlayer: nil, eventAwayPlayer: nil, eventFinalResult: nil, eventDateStart: nil, eventHomeFinalResult: nil, eventAwayFinalResult: nil)
        mockRepo.latestResultsResult = .success([event])
        
        let expectation = XCTestExpectation(description: "Get latest results")
        useCase.execute(leagueKey: 5)
            .sink(receiveCompletion: { _ in }, receiveValue: { events in
                XCTAssertEqual(events.count, 1)
                XCTAssertEqual(events.first?.eventKey, 11)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testGetTeamsUseCase() {
        let mockRepo = MockLeagueDetailsRepository()
        let useCase = GetTeamsUseCase(repository: mockRepo)
        let team = Team(teamKey: 20, teamName: "Arsenal", teamLogo: nil, playerKey: nil, playerName: nil, playerLogo: nil, playerImage: nil, players: nil)
        mockRepo.teamsResult = .success([team])
        
        let expectation = XCTestExpectation(description: "Get teams")
        useCase.execute(leagueKey: 5)
            .sink(receiveCompletion: { _ in }, receiveValue: { teams in
                XCTAssertEqual(teams.count, 1)
                XCTAssertEqual(teams.first?.teamName, "Arsenal")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testGetTeamDetailsUseCase() {
        let mockRepo = MockTeamDetailsRepository()
        let useCase = GetTeamDetailsUseCase(repository: mockRepo)
        let team = Team(teamKey: 30, teamName: "Chelsea", teamLogo: nil, playerKey: nil, playerName: nil, playerLogo: nil, playerImage: nil, players: nil)
        mockRepo.teamDetailsResult = .success([team])
        
        let expectation = XCTestExpectation(description: "Get team details")
        useCase.execute(sport: "football", teamId: 30)
            .sink(receiveCompletion: { _ in }, receiveValue: { teams in
                XCTAssertEqual(teams.count, 1)
                XCTAssertEqual(teams.first?.teamName, "Chelsea")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testSaveFirstEntryUseCase() {
        let mockRepo = MockUserRepository()
        let useCase = SaveFirstEntryUseCase(userRepo: mockRepo)
        
        useCase.execute(isFirstEntry: false)
        XCTAssertFalse(mockRepo.isFirstTime)
    }
    
    func testSaveThemeUseCase() {
        let mockRepo = MockUserRepository()
        let useCase = SaveThemeUseCase(userRepo: mockRepo)
        
        useCase.execute(isDarkMode: true)
        XCTAssertTrue(mockRepo.isDarkTheme)
    }
    
    func testSaveLanguageUseCase() {
        let mockRepo = MockUserRepository()
        let useCase = SaveLanguageUseCase(userRepo: mockRepo)
        
        useCase.execute(languageCode: "ar")
        XCTAssertEqual(mockRepo.language, "ar")
    }
    
    func testScheduleAlertUseCase_Granted() {
        let mockNotification = MockNotificationService()
        mockNotification.isAuthorized = true
        let useCase = ScheduleAlertUseCase(notificationService: mockNotification)
        
        let date = Date()
        useCase.execute(sportName: "tennis", eventName: "Match A", date: date)
        
        XCTAssertTrue(mockNotification.requestAuthorizationCalled)
        XCTAssertTrue(mockNotification.scheduleNotificationCalled)
        XCTAssertEqual(mockNotification.scheduledDate, date)
    }
    
    func testScheduleAlertUseCase_Denied() {
        let mockNotification = MockNotificationService()
        mockNotification.isAuthorized = false
        let useCase = ScheduleAlertUseCase(notificationService: mockNotification)
        
        useCase.execute(sportName: "tennis", eventName: "Match A", date: Date())
        
        XCTAssertTrue(mockNotification.requestAuthorizationCalled)
        XCTAssertFalse(mockNotification.scheduleNotificationCalled)
    }
}
