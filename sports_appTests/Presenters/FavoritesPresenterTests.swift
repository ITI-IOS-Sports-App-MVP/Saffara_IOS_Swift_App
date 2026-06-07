import XCTest
@testable import sports_app

final class FavoritesPresenterTests: XCTestCase {
    var sut: FavoritesPresenter!
    var mockView: MockFavoritesView!
    var mockGetFavoritesUseCase: MockGetFavoritesUseCase!
    var mockRemoveFavoriteUseCase: MockRemoveFavoriteUseCase!

    override func setUpWithError() throws {
        mockView = MockFavoritesView()
        mockGetFavoritesUseCase = MockGetFavoritesUseCase()
        mockRemoveFavoriteUseCase = MockRemoveFavoriteUseCase()

        sut = FavoritesPresenter(
            view: mockView,
            getFavoritesUseCase: mockGetFavoritesUseCase,
            removeFavoriteUseCase: mockRemoveFavoriteUseCase
        )
    }

    override func tearDownWithError() throws {
        sut = nil
        mockView = nil
        mockGetFavoritesUseCase = nil
        mockRemoveFavoriteUseCase = nil
    }

    func testViewDidLoad_WithFavorites_DisplaysFavorites() {
        // Arrange
        let league = League(leagueKey: 1, leagueName: "Test", leagueLogo: nil, leagueCountry: nil, sportName: "football")
        mockGetFavoritesUseCase.result = [league]

        // Act
        sut.viewDidLoad()

        // Assert
        XCTAssertTrue(mockView.displayFavoritesCalled)
        XCTAssertEqual(sut.getLeaguesCount(), 1)
    }

    func testViewDidLoad_EmptyFavorites_ShowsEmptyState() {
        // Arrange
        mockGetFavoritesUseCase.result = []

        // Act
        sut.viewDidLoad()

        // Assert
        XCTAssertTrue(mockView.showEmptyStateCalled)
        XCTAssertEqual(sut.getLeaguesCount(), 0)
    }

    func testViewDidLoad_Failure_ShowsError() {
        // Arrange
        mockGetFavoritesUseCase.shouldThrowError = true

        // Act
        sut.viewDidLoad()

        // Assert
        XCTAssertTrue(mockView.displayErrorCalled)
        XCTAssertNotNil(mockView.errorMessage)
    }

    func testRemoveFavorite_Success() {
        // Arrange
        let league = League(leagueKey: 1, leagueName: "Test", leagueLogo: nil, leagueCountry: nil, sportName: "football")
        mockGetFavoritesUseCase.result = [league]
        sut.viewDidLoad() // Load initial data

        // Act
        sut.removeFavorite(at: 0)

        // Assert
        XCTAssertEqual(mockRemoveFavoriteUseCase.removedLeagueKey, 1)
        XCTAssertTrue(mockView.showEmptyStateCalled) // It should be empty now
        XCTAssertEqual(sut.getLeaguesCount(), 0)
    }

    func testRemoveFavorite_Failure() {
        // Arrange
        let league = League(leagueKey: 1, leagueName: "Test", leagueLogo: nil, leagueCountry: nil, sportName: "football")
        mockGetFavoritesUseCase.result = [league]
        sut.viewDidLoad()
        mockRemoveFavoriteUseCase.shouldThrowError = true

        // Act
        sut.removeFavorite(at: 0)

        // Assert
        XCTAssertTrue(mockView.displayErrorCalled)
        XCTAssertEqual(sut.getLeaguesCount(), 1) // Data remains
    }

    func testFilterFavorites() {
        // Arrange
        let league1 = League(leagueKey: 1, leagueName: "Test", leagueLogo: nil, leagueCountry: nil, sportName: "football")
        let league2 = League(leagueKey: 2, leagueName: "Test2", leagueLogo: nil, leagueCountry: nil, sportName: "basketball")
        mockGetFavoritesUseCase.result = [league1, league2]
        sut.viewDidLoad()

        // Act - filter by football (index 1 is 'football' in the presenter)
        sut.filterFavorites(by: 1)

        // Assert
        XCTAssertEqual(sut.getLeaguesCount(), 1)
        XCTAssertTrue(mockView.displayFavoritesCalled)

        // Act - filter by something else that doesn't exist
        sut.filterFavorites(by: 3) // tennis

        // Assert
        XCTAssertEqual(sut.getLeaguesCount(), 0)
        XCTAssertTrue(mockView.showEmptyStateCalled)
    }

    func testDidSelectFavorite() {
        // Arrange
        let league = League(leagueKey: 1, leagueName: "Test", leagueLogo: nil, leagueCountry: nil, sportName: "football")
        mockGetFavoritesUseCase.result = [league]
        sut.viewDidLoad()

        // Act
        sut.didSelectFavorite(at: 0)

        // Assert
        XCTAssertEqual(mockView.navigatedToLeague?.leagueKey, 1)
    }

    func testViewWillAppear() {
        // Arrange
        let league = League(leagueKey: 1, leagueName: "Test", leagueLogo: nil, leagueCountry: nil, sportName: "football")
        mockGetFavoritesUseCase.result = [league]
        
        // Act
        sut.viewWillAppear()
        
        // Assert
        XCTAssertTrue(mockView.displayFavoritesCalled)
        XCTAssertEqual(sut.getLeaguesCount(), 1)
    }
    
    func testConfigureCell_WithValidIndex() {
        // Arrange
        let cell = MockLeagueCellView()
        let league = League(leagueKey: 1, leagueName: "La Liga", leagueLogo: "logo_url", leagueCountry: "Spain", sportName: "football")
        mockGetFavoritesUseCase.result = [league]
        sut.viewDidLoad()
        
        // Act
        sut.configureCell(cell, at: 0)
        
        // Assert
        XCTAssertEqual(cell.displayedName, "La Liga")
        XCTAssertEqual(cell.displayedCountry, "Spain")
        XCTAssertEqual(cell.displayedBadge, "logo_url")
    }
    
    func testConfigureCell_WithInvalidIndex_DoesNothing() {
        // Arrange
        let cell = MockLeagueCellView()
        let league = League(leagueKey: 1, leagueName: "La Liga", leagueLogo: "logo_url", leagueCountry: "Spain", sportName: "football")
        mockGetFavoritesUseCase.result = [league]
        sut.viewDidLoad()
        
        // Act
        sut.configureCell(cell, at: 99)
        
        // Assert
        XCTAssertNil(cell.displayedName)
    }
    
    func testRemoveFavorite_WithInvalidIndex_DoesNothing() {
        // Arrange
        let league = League(leagueKey: 1, leagueName: "Test", leagueLogo: nil, leagueCountry: nil, sportName: "football")
        mockGetFavoritesUseCase.result = [league]
        sut.viewDidLoad()
        
        // Act
        sut.removeFavorite(at: 99)
        
        // Assert
        XCTAssertNil(mockRemoveFavoriteUseCase.removedLeagueKey)
    }
    
    func testRemoveFavorite_WithMissingLeagueKey_DisplaysError() {
        // Arrange
        let league = League(leagueKey: nil, leagueName: "Test", leagueLogo: nil, leagueCountry: nil, sportName: "football")
        mockGetFavoritesUseCase.result = [league]
        sut.viewDidLoad()
        
        // Act
        sut.removeFavorite(at: 0)
        
        // Assert
        XCTAssertTrue(mockView.displayErrorCalled)
        XCTAssertEqual(mockView.errorMessage, "Unable to remove: Invalid League ID.")
    }
}
