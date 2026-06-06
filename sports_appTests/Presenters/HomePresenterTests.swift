import XCTest
@testable import sports_app

final class HomePresenterTests: XCTestCase {
    var sut: HomePresenter!
    var mockView: MockHomeView!
    var mockReadThemeUseCase: MockReadThemeUseCase!
    var mockSaveThemeUseCase: MockSaveThemeUseCase!
    var mockReadLanguageUseCase: MockReadLanguageUseCase!
    var mockSaveLanguageUseCase: MockSaveLanguageUseCase!

    override func setUpWithError() throws {
        mockView = MockHomeView()
        mockReadThemeUseCase = MockReadThemeUseCase()
        mockSaveThemeUseCase = MockSaveThemeUseCase()
        mockReadLanguageUseCase = MockReadLanguageUseCase()
        mockSaveLanguageUseCase = MockSaveLanguageUseCase()

        sut = HomePresenter(
            view: mockView,
            readThemeUseCase: mockReadThemeUseCase,
            saveThemeUseCase: mockSaveThemeUseCase,
            readLanguageUseCase: mockReadLanguageUseCase,
            saveLanguageUseCase: mockSaveLanguageUseCase
        )
    }

    override func tearDownWithError() throws {
        sut = nil
        mockView = nil
        mockReadThemeUseCase = nil
        mockSaveThemeUseCase = nil
        mockReadLanguageUseCase = nil
        mockSaveLanguageUseCase = nil
    }

    func testViewDidLoad_SetsInitialState() {
        // Arrange
        mockReadThemeUseCase.isDark = true
        mockReadLanguageUseCase.language = "ar"

        // Act
        sut.viewDidLoad()

        // Assert
        XCTAssertEqual(mockView.isDarkModeSet, true)
        XCTAssertEqual(mockView.languageCodeSet, "ar")
        XCTAssertTrue(mockView.reloadCollectionViewCalled)
        XCTAssertEqual(sut.getSportsCount(), 4) // 4 static sports added in fetchSportsData
    }

    func testToggleTheme() {
        // Arrange
        sut.viewDidLoad() // Loads initial false
        let initialDarkMode = mockView.isDarkModeSet

        // Act
        sut.toggleTheme()

        // Assert
        XCTAssertNotEqual(initialDarkMode, mockView.isDarkModeSet)
        XCTAssertEqual(mockSaveThemeUseCase.savedIsDark, mockView.isDarkModeSet)
    }

    func testToggleLanguage() {
        // Arrange
        mockReadLanguageUseCase.language = "en"
        sut.viewDidLoad()

        // Act
        sut.toggleLanguage()

        // Assert
        XCTAssertEqual(mockView.languageCodeSet, "ar")
        XCTAssertEqual(mockSaveLanguageUseCase.savedLanguage, "ar")
        
        // Act again
        sut.toggleLanguage()
        XCTAssertEqual(mockView.languageCodeSet, "en")
    }

    func testSearchSports_WithEmptyQuery() {
        // Arrange
        sut.viewDidLoad()
        
        // Act
        sut.searchSports(with: "")

        // Assert
        XCTAssertEqual(sut.getSportsCount(), 4)
    }

    func testSearchSports_WithValidQuery() {
        // Arrange
        sut.viewDidLoad() 
        
        // Act
        let firstSportName = sut.getSport(at: 0).name
        
        sut.searchSports(with: String(firstSportName.prefix(3)))
        
        // Assert
        XCTAssertTrue(sut.getSportsCount() >= 1, "Should find at least 1 sport matching the query")
        XCTAssertTrue(sut.getSport(at: 0).name.localizedCaseInsensitiveContains(String(firstSportName.prefix(3))))
    }

    func testDidSelectSport() {
        // Arrange
        sut.viewDidLoad()
        
        // Act
        sut.didSelectSport(at: 0) // Should select football

        // Assert
        XCTAssertEqual(mockView.navigatedToSport, "football")
    }
}
