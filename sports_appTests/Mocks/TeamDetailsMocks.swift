import Foundation
import Combine
@testable import sports_app

class MockGetTeamDetailsUseCase: GetTeamDetailsUseCaseProtocol {
    var result: Result<[Team], Error>?
    
    func execute(sport: String, teamId: Int) -> AnyPublisher<[Team], Error> {
        if let result = result {
            return result.publisher.eraseToAnyPublisher()
        }
        return Fail(error: NSError(domain: "test", code: -1, userInfo: nil)).eraseToAnyPublisher()
    }
}

class MockTeamDetailsView: TeamDetailsViewProtocol {
    var showLoadingIndicatorCalled = false
    var hideLoadingIndicatorCalled = false
    var displayTeamHeaderCalled = false
    var reloadPlayersListCalled = false
    var showErrorCalled = false
    var errorMessage: String?
    
    var headerName: String?
    var headerLogo: String?
    var headerSportAndLeague: String?
    
    func showLoadingIndicator() {
        showLoadingIndicatorCalled = true
    }
    
    func hideLoadingIndicator() {
        hideLoadingIndicatorCalled = true
    }
    
    func displayTeamHeader(name: String, logo: String?, sportAndLeague: String) {
        displayTeamHeaderCalled = true
        headerName = name
        headerLogo = logo
        headerSportAndLeague = sportAndLeague
    }
    
    func reloadPlayersList() {
        reloadPlayersListCalled = true
    }
    
    func showError(message: String) {
        showErrorCalled = true
        errorMessage = message
    }
}
