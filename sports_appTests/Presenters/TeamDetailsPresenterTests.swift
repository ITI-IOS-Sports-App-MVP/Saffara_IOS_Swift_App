import XCTest
import Combine
@testable import sports_app

final class TeamDetailsPresenterTests: XCTestCase {
    var sut: TeamDetailsPresenter!
    var mockView: MockTeamDetailsView!
    var mockGetTeamDetailsUseCase: MockGetTeamDetailsUseCase!

    override func setUpWithError() throws {
        mockView = MockTeamDetailsView()
        mockGetTeamDetailsUseCase = MockGetTeamDetailsUseCase()

        sut = TeamDetailsPresenter(
            view: mockView,
            getTeamDetailsUseCase: mockGetTeamDetailsUseCase,
            teamId: 1,
            sport: "football",
            sportAndLeague: "Football - Premier League"
        )
    }

    override func tearDownWithError() throws {
        sut = nil
        mockView = nil
        mockGetTeamDetailsUseCase = nil
    }

    func testViewDidLoad_Success() {
        // Arrange
        let player = Player(playerKey: 1, playerName: "Player 1", playerNumber: "10", playerImage: nil, playerType: "Forward", playerAge: "25", playerMatchPlayed: "10", playerGoals: "5", playerYellowCards: "1", playerRedCards: "0", playerRating: "9.0")
        let team = Team(teamKey: 1, teamName: "Test Team", teamLogo: "logo.png", playerKey: nil, playerName: nil, playerLogo: nil, playerImage: nil, players: [player])
        mockGetTeamDetailsUseCase.result = .success([team])

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
        XCTAssertTrue(mockView.displayTeamHeaderCalled)
        XCTAssertEqual(mockView.headerName, "Test Team")
        XCTAssertEqual(mockView.headerLogo, "logo.png")
        XCTAssertTrue(mockView.reloadPlayersListCalled)
        XCTAssertEqual(sut.getPlayersCount(), 1)
        XCTAssertEqual(sut.getPlayer(at: 0).playerName, "Player 1")
    }

    func testViewDidLoad_Failure() {
        // Arrange
        mockGetTeamDetailsUseCase.result = .failure(NSError(domain: "test", code: 404, userInfo: [NSLocalizedDescriptionKey: "Not Found"]))

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
        XCTAssertTrue(mockView.showErrorCalled)
        XCTAssertEqual(mockView.errorMessage, "Not Found")
    }
    
    func testViewDidLoad_EmptyTeamArray() {
        // Arrange
        mockGetTeamDetailsUseCase.result = .success([])

        // Act
        sut.viewDidLoad()
        
        let expectation = XCTestExpectation(description: "Wait for main queue")
        DispatchQueue.main.async {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)

        // Assert
        XCTAssertTrue(mockView.showErrorCalled)
        XCTAssertEqual(mockView.errorMessage, "Team details not found.")
    }
}
