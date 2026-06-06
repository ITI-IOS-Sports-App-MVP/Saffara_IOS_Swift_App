import XCTest
@testable import sports_app

final class SettingsPresenterTests: XCTestCase {
    var sut: SettingsPresenter!
    var mockView: MockSettingsView!
    var mockReadTheme: MockReadThemeUseCase!
    var mockSaveTheme: MockSaveThemeUseCase!
    var mockReadLanguage: MockReadLanguageUseCase!
    var mockSaveLanguage: MockSaveLanguageUseCase!
    
    override func setUpWithError() throws {
        mockView = MockSettingsView()
        mockReadTheme = MockReadThemeUseCase()
        mockSaveTheme = MockSaveThemeUseCase()
        mockReadLanguage = MockReadLanguageUseCase()
        mockSaveLanguage = MockSaveLanguageUseCase()
        
        sut = SettingsPresenter(
            view: mockView,
            readThemeUseCase: mockReadTheme,
            saveThemeUseCase: mockSaveTheme,
            readLanguageUseCase: mockReadLanguage,
            saveLanguageUseCase: mockSaveLanguage
        )
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mockView = nil
        mockReadTheme = nil
        mockSaveTheme = nil
        mockReadLanguage = nil
        mockSaveLanguage = nil
    }
    
    func testViewDidLoad_InitializesCorrectly() {
        // Arrange
        mockReadTheme.isDark = true
        mockReadLanguage.language = "ar"
        
        // Act
        sut.viewDidLoad()
        
        // Assert
        XCTAssertEqual(sut.getCurrentThemeIsDark(), true)
        XCTAssertEqual(sut.getCurrentLanguageCode(), "ar")
        XCTAssertEqual(mockView.updatedThemeIsDark, true)
        XCTAssertEqual(mockView.updatedLanguageCode, "ar")
    }
    
    func testDidSelectTheme_UpdatesStateAndTriggersView() {
        // Act
        sut.didSelectTheme(isDarkMode: true)
        
        // Assert
        XCTAssertEqual(sut.getCurrentThemeIsDark(), true)
        XCTAssertEqual(mockSaveTheme.savedIsDark, true)
        XCTAssertEqual(mockView.updatedThemeIsDark, true)
        XCTAssertEqual(mockView.appliedThemeIsDark, true)
    }
    
    func testDidSelectLanguage_UpdatesStateAndTriggersView() {
        // Act
        sut.didSelectLanguage(languageCode: "ar")
        
        // Assert
        XCTAssertEqual(sut.getCurrentLanguageCode(), "ar")
        XCTAssertEqual(mockSaveLanguage.savedLanguage, "ar")
        XCTAssertEqual(mockView.updatedLanguageCode, "ar")
        XCTAssertEqual(mockView.appliedLanguageCode, "ar")
    }
}
