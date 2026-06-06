import XCTest
@testable import sports_app

final class OnboardingPresenterTests: XCTestCase {
    var sut: OnboardingPresenter!
    var mockView: MockOnboardingView!
    var mockSaveFirstEntry: MockSaveFirstEntryUseCase!
    
    override func setUpWithError() throws {
        mockView = MockOnboardingView()
        mockSaveFirstEntry = MockSaveFirstEntryUseCase()
        
        sut = OnboardingPresenter(
            view: mockView,
            saveFirstEntryUseCase: mockSaveFirstEntry
        )
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mockView = nil
        mockSaveFirstEntry = nil
    }
    
    func testOnGetStartedTapped_SavesEntryAndNavigates() {
        // Act
        sut.onGetStartedTapped()
        
        // Assert
        XCTAssertEqual(mockSaveFirstEntry.savedIsFirstEntry, false)
        XCTAssertTrue(mockView.navigateToHomeCalled)
    }
    
    func testOnSkipTapped_SavesEntryAndNavigates() {
        // Act
        sut.onSkipTapped()
        
        // Assert
        XCTAssertEqual(mockSaveFirstEntry.savedIsFirstEntry, false)
        XCTAssertTrue(mockView.navigateToHomeCalled)
    }
}
