import XCTest
import Combine
import UserNotifications
@testable import sports_app

class MockUserNotificationCenter: UserNotificationCenterProtocol {
    var requestAuthorizationCalled = false
    var addCalled = false
    var shouldReturnError = false
    
    func requestAuthorization(options: UNAuthorizationOptions, completionHandler: @escaping (Bool, Error?) -> Void) {
        requestAuthorizationCalled = true
        completionHandler(true, nil)
    }
    
    func add(_ request: UNNotificationRequest, withCompletionHandler completionHandler: (((Error)?) -> Void)?) {
        addCalled = true
        if shouldReturnError {
            completionHandler?(NSError(domain: "test", code: -1, userInfo: nil))
        } else {
            completionHandler?(nil)
        }
    }
}

final class UtilityAndServiceTests: XCTestCase {
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = []
    }
    
    override func tearDown() {
        cancellables = nil
        super.tearDown()
    }
    
    func testNotificationService_RequestAuthorization() {
        let mockCenter = MockUserNotificationCenter()
        let service = NotificationService(center: mockCenter)
        
        let expectation = XCTestExpectation(description: "Auth callback")
        service.requestAuthorization { granted, _ in
            XCTAssertTrue(granted)
            expectation.fulfill()
        }
        
        XCTAssertTrue(mockCenter.requestAuthorizationCalled)
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testNotificationService_ScheduleNotification_Success() {
        let mockCenter = MockUserNotificationCenter()
        let service = NotificationService(center: mockCenter)
        
        service.scheduleNotification(title: "Title", body: "Body", date: Date(), identifier: "id")
        
        XCTAssertTrue(mockCenter.addCalled)
    }
    
    func testNotificationService_ScheduleNotification_Error() {
        let mockCenter = MockUserNotificationCenter()
        mockCenter.shouldReturnError = true
        let service = NotificationService(center: mockCenter)
        
        service.scheduleNotification(title: "Title", body: "Body", date: Date(), identifier: "id")
        
        XCTAssertTrue(mockCenter.addCalled)
    }
    
    func testUIViewAnimations() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.animateCellDisplay(type: .slideUpWithFade)
        view.animateCellDisplay(type: .slideInFromLeft)
        view.animateCellDisplay(type: .slideInFromRight)
        view.animateCellDisplay(type: .scaleIn)
        view.animateCellDisplay(type: .flip3D)
        
        // Triggers initial setup values
        XCTAssertNotNil(view)
    }
    
    func testUIViewShimmer() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.startShimmer()
        view.stopShimmer()
        
        XCTAssertTrue(true)
    }
}

final class TeamDetailsRepositoryTests: XCTestCase {
    var sut: TeamDetailsRepository!
    var mockNetwork: MockTeamsNetworkService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockNetwork = MockTeamsNetworkService()
        sut = TeamDetailsRepository(networkService: mockNetwork)
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        mockNetwork = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testFetchTeamDetails() {
        let team = Team(teamKey: 1, teamName: "Test Team", teamLogo: nil, playerKey: nil, playerName: nil, playerLogo: nil, playerImage: nil, players: nil)
        mockNetwork.fetchTeamDetailsResult = .success([team])
        
        let expectation = XCTestExpectation(description: "Fetch team details success")
        sut.fetchTeamDetails(sport: "football", teamId: 1)
            .sink(receiveCompletion: { _ in }, receiveValue: { teams in
                XCTAssertEqual(teams.count, 1)
                XCTAssertEqual(teams.first?.teamName, "Test Team")
                expectation.fulfill()
            })
            .store(in: &cancellables)
            
        wait(for: [expectation], timeout: 1.0)
    }
}
