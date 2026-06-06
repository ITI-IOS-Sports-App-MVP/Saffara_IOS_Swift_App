import XCTest
import Combine
@testable import sports_app

final class LeagueDetailsPresenterTests: XCTestCase {
    var sut: LeagueDetailsPresenter!
    var mockView: MockLeagueDetailsView!
    var mockGetUpcomingUseCase: MockGetUpcomingEventsUseCase!
    var mockGetLatestUseCase: MockGetLatestResultsUseCase!
    var mockGetTeamsUseCase: MockGetTeamsUseCase!
    var mockFavoriteRepository: MockFavoriteLeaguesRepository!
    var mockScheduleAlertUseCase: MockScheduleAlertUseCase!

    override func setUpWithError() throws {
        mockView = MockLeagueDetailsView()
        mockGetUpcomingUseCase = MockGetUpcomingEventsUseCase()
        mockGetLatestUseCase = MockGetLatestResultsUseCase()
        mockGetTeamsUseCase = MockGetTeamsUseCase()
        mockFavoriteRepository = MockFavoriteLeaguesRepository()
        mockScheduleAlertUseCase = MockScheduleAlertUseCase()

        let league = League(leagueKey: 1, leagueName: "Test", leagueLogo: nil, leagueCountry: nil, sportName: "football")

        sut = LeagueDetailsPresenter(
            view: mockView,
            league: league,
            sport: "football",
            favoriteRepository: mockFavoriteRepository,
            getUpcomingUseCase: mockGetUpcomingUseCase,
            getLatestUseCase: mockGetLatestUseCase,
            getTeamsUseCase: mockGetTeamsUseCase,
            scheduleAlertUseCase: mockScheduleAlertUseCase
        )
    }

    override func tearDownWithError() throws {
        sut = nil
        mockView = nil
        mockGetUpcomingUseCase = nil
        mockGetLatestUseCase = nil
        mockGetTeamsUseCase = nil
        mockFavoriteRepository = nil
        mockScheduleAlertUseCase = nil
    }

    func testViewDidLoad_Success() {
        // Arrange
        let event = Event(eventKey: 1, eventDate: nil, eventTime: nil, eventHomeTeam: nil, eventAwayTeam: nil, homeTeamLogo: nil, awayTeamLogo: nil, eventHomeTeamLogo: nil, eventAwayTeamLogo: nil, eventFirstPlayer: nil, eventSecondPlayer: nil, eventFirstPlayerLogo: nil, eventSecondPlayerLogo: nil, eventHomePlayer: nil, eventAwayPlayer: nil, eventFinalResult: nil, eventDateStart: nil, eventHomeFinalResult: nil, eventAwayFinalResult: nil)
        let team = Team(teamKey: 1, teamName: "Test Team", teamLogo: nil, playerKey: nil, playerName: nil, playerLogo: nil, playerImage: nil, players: nil)
        
        mockGetUpcomingUseCase.result = .success([event])
        mockGetLatestUseCase.result = .success([event])
        mockGetTeamsUseCase.result = .success([team])
        
        let league = League(leagueKey: 1, leagueName: "Test", leagueLogo: nil, leagueCountry: nil, sportName: "football")
        mockFavoriteRepository.leagues = [league] // set as favorite

        // Act
        sut.viewDidLoad()
        
        let expectation = XCTestExpectation(description: "Wait for main queue")
        DispatchQueue.main.async {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)

        // Assert
        XCTAssertTrue(mockView.showLoadingIndicatorCalled)
        XCTAssertTrue(mockView.hideLoadingIndicatorCalled)
        XCTAssertTrue(mockView.displayUpcomingEventsCalled)
        XCTAssertTrue(mockView.displayLatestResultsCalled)
        XCTAssertTrue(mockView.displayTeamsCalled)
        XCTAssertTrue(mockView.updateFavoriteIconCalled)
        XCTAssertEqual(mockView.isFavoriteSet, true)
        XCTAssertEqual(sut.upcomingEvents.count, 1)
        XCTAssertEqual(sut.latestResults.count, 1)
        XCTAssertEqual(sut.teams.count, 1)
        XCTAssertFalse(mockView.showErrorCalled)
    }

    func testViewDidLoad_Failure() {
        // Arrange
        mockGetUpcomingUseCase.result = .failure(NSError(domain: "test", code: 404, userInfo: [NSLocalizedDescriptionKey: "Not Found"]))
        mockGetLatestUseCase.result = .failure(NSError(domain: "test", code: 404, userInfo: [NSLocalizedDescriptionKey: "Not Found"]))
        mockGetTeamsUseCase.result = .failure(NSError(domain: "test", code: 404, userInfo: [NSLocalizedDescriptionKey: "Not Found"]))

        // Act
        sut.viewDidLoad()
        
        let expectation = XCTestExpectation(description: "Wait for main queue")
        DispatchQueue.main.async {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)

        // Assert
        // In the presenter, if it fails it just emits empty arrays because it `.catch { _ in Just([]) }`
        // So no error should be shown in this implementation!
        XCTAssertFalse(mockView.showErrorCalled)
        XCTAssertEqual(sut.upcomingEvents.count, 0)
    }

    func testFavoriteButtonTapped_WhenNotFavorite_AddsFavorite() {
        // Arrange
        sut.viewDidLoad() // Loads with isFavorite = false

        // Act
        sut.favoriteButtonTapped()

        // Assert
        XCTAssertTrue(mockFavoriteRepository.leagues.contains(where: { $0.leagueKey == 1 }))
        XCTAssertTrue(mockView.updateFavoriteIconCalled)
        XCTAssertEqual(mockView.isFavoriteSet, true)
    }

    func testFavoriteButtonTapped_WhenIsFavorite_RemovesFavorite() {
        // Arrange
        let league = League(leagueKey: 1, leagueName: "Test", leagueLogo: nil, leagueCountry: nil, sportName: "football")
        mockFavoriteRepository.leagues = [league] // set as favorite
        sut.viewDidLoad() // sets isFavorite = true

        // Act
        sut.favoriteButtonTapped()

        // Assert
        XCTAssertFalse(mockFavoriteRepository.leagues.contains(where: { $0.leagueKey == 1 }))
        XCTAssertTrue(mockView.updateFavoriteIconCalled)
        XCTAssertEqual(mockView.isFavoriteSet, false)
    }

    func testViewWillAppear() {
        // Act
        sut.viewWillAppear()
        
        // Assert
        XCTAssertNotNil(mockView.notificationIconIsSet)
    }
    
    func testGetEvent_And_GetTeam_ReturnsCorrectValues() {
        // Arrange
        let event = Event(eventKey: 55, eventDate: nil, eventTime: nil, eventHomeTeam: nil, eventAwayTeam: nil, homeTeamLogo: nil, awayTeamLogo: nil, eventHomeTeamLogo: nil, eventAwayTeamLogo: nil, eventFirstPlayer: nil, eventSecondPlayer: nil, eventFirstPlayerLogo: nil, eventSecondPlayerLogo: nil, eventHomePlayer: nil, eventAwayPlayer: nil, eventFinalResult: nil, eventDateStart: nil, eventHomeFinalResult: nil, eventAwayFinalResult: nil)
        let team = Team(teamKey: 77, teamName: "Arsenal", teamLogo: nil, playerKey: nil, playerName: nil, playerLogo: nil, playerImage: nil, players: nil)
        sut.upcomingEvents = [event]
        sut.latestResults = [event]
        sut.teams = [team]
        
        // Assert
        XCTAssertEqual(sut.getUpcomingEvent(at: 0).eventKey, 55)
        XCTAssertEqual(sut.getLatestResult(at: 0).eventKey, 55)
        XCTAssertEqual(sut.getTeam(at: 0).teamKey, 77)
    }
    
    func testFavoriteButtonTapped_WhenOffline_ShowsError() {
        // Arrange
        NetworkMonitor.shared.mockIsConnected = false
        
        // Act
        sut.favoriteButtonTapped()
        
        // Assert
        XCTAssertNotNil(mockView.showErrorTitle)
        XCTAssertNotNil(mockView.showErrorMessage)
        NetworkMonitor.shared.mockIsConnected = nil
    }
    
    func testFavoriteButtonTapped_WhenThrowsError_ShowsError() {
        // Arrange
        NetworkMonitor.shared.mockIsConnected = true
        mockFavoriteRepository.shouldThrowError = true
        
        // Act
        sut.favoriteButtonTapped()
        
        // Assert
        XCTAssertNotNil(mockView.showErrorTitle)
        XCTAssertNotNil(mockView.showErrorMessage)
        NetworkMonitor.shared.mockIsConnected = nil
    }
    
    func testScheduleAlert_And_AlertDidFire() {
        // Act
        sut.scheduleAlert(for: Date())
        
        // Assert
        XCTAssertEqual(mockScheduleAlertUseCase.executedSportName, "football")
        XCTAssertEqual(mockView.successMessageShown, "alert_set_successfully".localized)
        XCTAssertEqual(mockView.notificationIconIsSet, true)
        
        // Act
        sut.alertDidFire()
        
        // Assert
        XCTAssertEqual(mockView.notificationIconIsSet, false)
    }
}
