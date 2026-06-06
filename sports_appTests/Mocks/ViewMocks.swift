import Foundation
@testable import sports_app

class MockHomeView: HomeViewProtocol {
    var reloadCollectionViewCalled = false
    var isDarkModeSet: Bool?
    var languageCodeSet: String?
    var navigatedToSport: String?
    
    func reloadCollectionView() {
        reloadCollectionViewCalled = true
    }
    
    func updateThemeIcon(isDarkMode: Bool) {
        isDarkModeSet = isDarkMode
    }
    
    func updateLanguageLabel(languageCode: String) {
        languageCodeSet = languageCode
    }
    
    func applyTheme(isDarkMode: Bool) {
        isDarkModeSet = isDarkMode
    }
    
    func applyLanguage(languageCode: String, isInitial: Bool) {
        languageCodeSet = languageCode
    }
    
    func navigateToLeagues(with sportName: String) {
        navigatedToSport = sportName
    }
}

class MockFavoritesView: FavoritesViewProtocol {
    var displayFavoritesCalled = false
    var displayErrorCalled = false
    var errorMessage: String?
    var showEmptyStateCalled = false
    var navigatedToLeague: League?
    
    func displayFavorites() {
        displayFavoritesCalled = true
    }
    
    func displayError(_ message: String) {
        displayErrorCalled = true
        errorMessage = message
    }
    
    func showEmptyState() {
        showEmptyStateCalled = true
    }
    
    func navigateToLeagueDetails(with league: League, sportName: String) {
        navigatedToLeague = league
    }
}

class MockLeaguesView: LeaguesViewProtocol {
    var showLoadingIndicatorCalled = false
    var hideLoadingIndicatorCalled = false
    var reloadTableViewCalled = false
    var showErrorCalled = false
    var errorMessage: String?
    var navigatedToLeague: League?
    
    func showLoadingIndicator() {
        showLoadingIndicatorCalled = true
    }
    
    func hideLoadingIndicator() {
        hideLoadingIndicatorCalled = true
    }
    
    func reloadTableView() {
        reloadTableViewCalled = true
    }
    
    func showError(message: String) {
        showErrorCalled = true
        errorMessage = message
    }
    
    func navigateToLeagueDetails(with league: League, sportName: String) {
        navigatedToLeague = league
    }
}

class MockLeagueCellView: LeagueCellViewProtocol {
    var displayedName: String?
    var displayedBadge: String?
    var displayedCountry: String?
    
    func displayLeagueName(_ name: String) {
        displayedName = name
    }
    
    func displayLeagueBadge(from urlString: String) {
        displayedBadge = urlString
    }
    
    func displayLeagueCountry(_ country: String) {
        displayedCountry = country
    }
}

class MockLeagueDetailsView: LeagueDetailsViewProtocol {
    var showErrorTitle: String?
    var showErrorMessage: String?
    var successMessageShown: String?
    var notificationIconIsSet: Bool?

    func showError(title: String, message: String) {
        showErrorTitle = title
        showErrorMessage = message
    }
    
    func showSuccessMessage(_ message: String) {
        successMessageShown = message
    }
    
    func updateNotificationIcon(isSet: Bool) {
        notificationIconIsSet = isSet
    }
    
    var showLoadingIndicatorCalled = false
    var hideLoadingIndicatorCalled = false
    var displayUpcomingEventsCalled = false
    var displayLatestResultsCalled = false
    var displayTeamsCalled = false
    var showErrorCalled = false
    var errorMessage: String?
    var updateFavoriteIconCalled = false
    var isFavoriteSet: Bool?
    
    func showLoadingIndicator() {
        showLoadingIndicatorCalled = true
    }
    
    func hideLoadingIndicator() {
        hideLoadingIndicatorCalled = true
    }
    
    func displayUpcomingEvents() {
        displayUpcomingEventsCalled = true
    }
    
    func displayLatestResults() {
        displayLatestResultsCalled = true
    }
    
    func displayTeams() {
        displayTeamsCalled = true
    }
    
    func showError(message: String) {
        showErrorCalled = true
        errorMessage = message
    }
    
    func updateFavoriteIcon(isFavorite: Bool) {
        updateFavoriteIconCalled = true
        isFavoriteSet = isFavorite
    }
}

class MockSettingsView: SettingsViewProtocol {
    var updatedThemeIsDark: Bool?
    var updatedLanguageCode: String?
    var appliedThemeIsDark: Bool?
    var appliedLanguageCode: String?
    
    func updateThemeSelection(isDarkMode: Bool) {
        updatedThemeIsDark = isDarkMode
    }
    
    func updateLanguageSelection(languageCode: String) {
        updatedLanguageCode = languageCode
    }
    
    func applyTheme(isDarkMode: Bool) {
        appliedThemeIsDark = isDarkMode
    }
    
    func applyLanguage(languageCode: String) {
        appliedLanguageCode = languageCode
    }
}

class MockOnboardingView: OnboardingViewProtocol {
    var navigateToHomeCalled = false
    func navigateToHome() {
        navigateToHomeCalled = true
    }
}
