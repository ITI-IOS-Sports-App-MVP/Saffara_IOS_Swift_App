import XCTest
import Combine
@testable import sports_app

final class LeaguesPresenterTests: XCTestCase {
    var sut: LeaguesPresenter!
    var mockView: MockLeaguesView!
    var mockGetLeaguesUseCase: MockGetLeaguesUseCase!

    override func setUpWithError() throws {
        mockView = MockLeaguesView()
        mockGetLeaguesUseCase = MockGetLeaguesUseCase()

        sut = LeaguesPresenter(
            view: mockView,
            getLeaguesUseCase: mockGetLeaguesUseCase,
            sportName: "football"
        )
    }

    override func tearDownWithError() throws {
        sut = nil
        mockView = nil
        mockGetLeaguesUseCase = nil
    }

    func testViewDidLoad_Success() {
        // Arrange
        let league = League(leagueKey: 1, leagueName: "Test", leagueLogo: nil, leagueCountry: nil, sportName: "football")
        mockGetLeaguesUseCase.result = .success([league])

        // Act
        sut.viewDidLoad()
        
        // Wait for RunLoop since Combine uses receive(on: DispatchQueue.main)
        let expectation = XCTestExpectation(description: "Wait for main queue")
        DispatchQueue.main.async {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)

        // Assert
        XCTAssertTrue(mockView.showLoadingIndicatorCalled)
        XCTAssertTrue(mockView.hideLoadingIndicatorCalled)
        XCTAssertTrue(mockView.reloadTableViewCalled)
        XCTAssertEqual(sut.getLeaguesCount(), 1)
        XCTAssertFalse(mockView.showErrorCalled)
    }

    func testViewDidLoad_Failure() {
        // Arrange
        mockGetLeaguesUseCase.result = .failure(NSError(domain: "test", code: 404, userInfo: [NSLocalizedDescriptionKey: "Not Found"]))

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
        XCTAssertEqual(sut.getLeaguesCount(), 0)
    }

    func testConfigureCell() {
        // Arrange
        let league = League(leagueKey: 1, leagueName: "Test League", leagueLogo: "test.png", leagueCountry: "Test Country", sportName: "football")
        mockGetLeaguesUseCase.result = .success([league])
        sut.viewDidLoad()
        
        let expectation = XCTestExpectation(description: "Wait for main queue")
        DispatchQueue.main.async {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)

        let mockCell = MockLeagueCellView()

        // Act
        sut.configureCell(mockCell, at: 0)

        // Assert
        XCTAssertEqual(mockCell.displayedName, "Test League")
        XCTAssertEqual(mockCell.displayedBadge, "test.png")
        XCTAssertEqual(mockCell.displayedCountry, "Test Country")
    }

    func testDidSelectRow() {
        // Arrange
        let league = League(leagueKey: 1, leagueName: "Test", leagueLogo: nil, leagueCountry: nil, sportName: "football")
        mockGetLeaguesUseCase.result = .success([league])
        sut.viewDidLoad()
        
        let expectation = XCTestExpectation(description: "Wait for main queue")
        DispatchQueue.main.async {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)

        // Act
        sut.didSelectRow(at: 0)

        // Assert
        XCTAssertEqual(mockView.navigatedToLeague?.leagueKey, 1)
    }
}
