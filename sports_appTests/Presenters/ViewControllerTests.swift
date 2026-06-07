import XCTest
@testable import sports_app

final class ViewControllerTests: XCTestCase {
    
    var storyboard: UIStoryboard!
    
    override func setUp() {
        super.setUp()
        // Use bundle of LeaguesViewController to load the storyboard
        storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: LeaguesViewController.self))
    }
    
    override func tearDown() {
        storyboard = nil
        super.tearDown()
    }
    
    func testHomeViewController() {
        guard let vc = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else {
            XCTFail("Could not instantiate HomeViewController")
            return
        }
        
        let presenter = HomePresenter(
            view: vc,
            readThemeUseCase: MockReadThemeUseCase(),
            saveThemeUseCase: MockSaveThemeUseCase(),
            readLanguageUseCase: MockReadLanguageUseCase(),
            saveLanguageUseCase: MockSaveLanguageUseCase()
        )
        vc.presenter = presenter
        
        // Load view hierarchy
        _ = vc.view
        
        // Fetch sports data is called in presenter.viewDidLoad() which is called in vc.viewDidLoad()
        let count = vc.collectionView(vc.collectionView, numberOfItemsInSection: 0)
        XCTAssertTrue(count > 0)
        
        let indexPath = IndexPath(item: 0, section: 0)
        let cell = vc.collectionView(vc.collectionView, cellForItemAt: indexPath) as? HomeCollectionViewCell
        XCTAssertNotNil(cell)
        
        vc.collectionView(vc.collectionView, didSelectItemAt: indexPath)
        
        vc.searchBar(UISearchBar(), textDidChange: "football")
        vc.applyTheme(isDarkMode: true)
        vc.applyLanguage(languageCode: "ar", isInitial: false)
    }
    
    func testSettingsViewController() {
        guard let vc = storyboard.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController else {
            XCTFail("Could not instantiate SettingsViewController")
            return
        }
        
        let presenter = SettingsPresenter(
            view: vc,
            readThemeUseCase: MockReadThemeUseCase(),
            saveThemeUseCase: MockSaveThemeUseCase(),
            readLanguageUseCase: MockReadLanguageUseCase(),
            saveLanguageUseCase: MockSaveLanguageUseCase()
        )
        vc.presenter = presenter
        
        _ = vc.view
        
        vc.updateThemeSelection(isDarkMode: true)
        vc.updateLanguageSelection(languageCode: "en")
        vc.applyTheme(isDarkMode: true)
        vc.applyLanguage(languageCode: "en")
    }
    
    func testLeaguesViewController() {
        guard let vc = storyboard.instantiateViewController(withIdentifier: "LeaguesViewController") as? LeaguesViewController else {
            XCTFail("Could not instantiate LeaguesViewController")
            return
        }
        
        let mockUseCase = MockGetLeaguesUseCase()
        let league = League(leagueKey: 1, leagueName: "La Liga", leagueLogo: "logo", leagueCountry: "Spain", sportName: "football")
        mockUseCase.result = .success([league])
        
        let presenter = LeaguesPresenter(view: vc, getLeaguesUseCase: mockUseCase, sportName: "football")
        vc.presenter = presenter
        
        _ = vc.view
        
        vc.showLoadingIndicator()
        vc.hideLoadingIndicator()
        vc.reloadTableView()
        
        let count = vc.tableView(vc.tableView, numberOfRowsInSection: 0)
        XCTAssertEqual(count, 1)
        
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = vc.tableView(vc.tableView, cellForRowAt: indexPath) as? LeagueTableViewCell
        XCTAssertNotNil(cell)
        
        vc.tableView(vc.tableView, willDisplay: cell!, forRowAt: indexPath)
        vc.tableView(vc.tableView, didSelectRowAt: indexPath)
        
        vc.showError(message: "Error")
        vc.navigateToLeagueDetails(with: league, sportName: "football")
        
        let skView = LeaguesSkeletonView(frame: .zero)
        skView.startShimmering()
        skView.stopShimmering()
        
        let cellMock = Bundle(for: LeagueTableViewCell.self).loadNibNamed("LeagueTableViewCell", owner: nil, options: nil)?.first as? LeagueTableViewCell
        XCTAssertNotNil(cellMock)
        cellMock?.prepareForReuse()
        cellMock?.setSelected(true, animated: false)
        cellMock?.displayLeagueName("La Liga")
        cellMock?.displayLeagueCountry("Spain")
        cellMock?.displayLeagueBadge(from: "http://example.com/logo.png")
        cellMock?.animateCellDisplay(type: .slideUpWithFade)
    }
    
    func testFavoriteTableViewController() {
        guard let vc = storyboard.instantiateViewController(withIdentifier: "FavoriteTableViewController") as? FavoriteTableViewController else {
            XCTFail("Could not instantiate FavoriteTableViewController")
            return
        }
        
        let mockGetUseCase = MockGetFavoritesUseCase()
        let league = League(leagueKey: 1, leagueName: "La Liga", leagueLogo: "logo", leagueCountry: "Spain", sportName: "football")
        mockGetUseCase.result = [league]
        
        let presenter = FavoritesPresenter(
            view: vc,
            getFavoritesUseCase: mockGetUseCase,
            removeFavoriteUseCase: MockRemoveFavoriteUseCase()
        )
        vc.presenter = presenter
        
        _ = vc.view
        
        vc.showEmptyState()
        vc.displayFavorites()
        vc.viewWillAppear(false)
        
        let count = vc.tableView(vc.tableView, numberOfRowsInSection: 0)
        XCTAssertEqual(count, 1)
        
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = vc.tableView(vc.tableView, cellForRowAt: indexPath) as? LeagueTableViewCell
        XCTAssertNotNil(cell)
        
        vc.tableView(vc.tableView, willDisplay: cell!, forRowAt: indexPath)
        vc.tableView(vc.tableView, didSelectRowAt: indexPath)
        vc.tableView(vc.tableView, commit: .delete, forRowAt: indexPath)
        
        let segment = UISegmentedControl()
        segment.selectedSegmentIndex = 1
        vc.perform(Selector(("filterSegmentChanged:")), with: segment)
        
        vc.displayError("Error message")
        vc.navigateToLeagueDetails(with: league, sportName: "football")
    }
    
    func testLeagueDetailsViewController() {
        guard let vc = storyboard.instantiateViewController(withIdentifier: "LeagueDetailsViewController") as? LeagueDetailsViewController else {
            XCTFail("Could not instantiate LeagueDetailsViewController")
            return
        }
        
        let league = League(leagueKey: 1, leagueName: "Test", leagueLogo: nil, leagueCountry: nil, sportName: "football")
        let presenter = LeagueDetailsPresenter(
            view: vc,
            league: league,
            sport: "football",
            favoriteRepository: MockFavoriteLeaguesRepository(),
            getUpcomingUseCase: MockGetUpcomingEventsUseCase(),
            getLatestUseCase: MockGetLatestResultsUseCase(),
            getTeamsUseCase: MockGetTeamsUseCase(),
            scheduleAlertUseCase: MockScheduleAlertUseCase()
        )
        vc.presenter = presenter
        
        _ = vc.view
        vc.viewWillAppear(false)
        
        vc.showLoadingIndicator()
        vc.hideLoadingIndicator()
        
        let upcomingEvent = Event(eventKey: 1, eventDate: "2026-06-06", eventTime: "18:00", eventHomeTeam: "A", eventAwayTeam: "B", homeTeamLogo: nil, awayTeamLogo: nil, eventHomeTeamLogo: nil, eventAwayTeamLogo: nil, eventFirstPlayer: nil, eventSecondPlayer: nil, eventFirstPlayerLogo: nil, eventSecondPlayerLogo: nil, eventHomePlayer: nil, eventAwayPlayer: nil, eventFinalResult: nil, eventDateStart: nil, eventHomeFinalResult: nil, eventAwayFinalResult: nil)
        let latestResult = Event(eventKey: 2, eventDate: "2026-06-05", eventTime: "18:00", eventHomeTeam: "C", eventAwayTeam: "D", homeTeamLogo: nil, awayTeamLogo: nil, eventHomeTeamLogo: nil, eventAwayTeamLogo: nil, eventFirstPlayer: nil, eventSecondPlayer: nil, eventFirstPlayerLogo: nil, eventSecondPlayerLogo: nil, eventHomePlayer: nil, eventAwayPlayer: nil, eventFinalResult: "2-1", eventDateStart: nil, eventHomeFinalResult: nil, eventAwayFinalResult: nil)
        let team = Team(teamKey: 1, teamName: "Team E", teamLogo: nil, playerKey: nil, playerName: nil, playerLogo: nil, playerImage: nil, players: nil)
        
        presenter.upcomingEvents = [upcomingEvent]
        presenter.latestResults = [latestResult]
        presenter.teams = [team]
        
        vc.displayUpcomingEvents()
        vc.displayLatestResults()
        vc.displayTeams()
        vc.updateFavoriteIcon(isFavorite: true)
        vc.updateNotificationIcon(isSet: true)
        
        // Call UICollectionView DataSource methods
        let sections = vc.numberOfSections(in: vc.collectionView)
        XCTAssertEqual(sections, 3)
        
        let items0 = vc.collectionView(vc.collectionView, numberOfItemsInSection: 0)
        XCTAssertEqual(items0, 1)
        let items1 = vc.collectionView(vc.collectionView, numberOfItemsInSection: 1)
        XCTAssertEqual(items1, 1)
        let items2 = vc.collectionView(vc.collectionView, numberOfItemsInSection: 2)
        XCTAssertEqual(items2, 1)
        
        let cell0 = vc.collectionView(vc.collectionView, cellForItemAt: IndexPath(item: 0, section: 0)) as? EventCollectionViewCell
        XCTAssertNotNil(cell0)
        let cell1 = vc.collectionView(vc.collectionView, cellForItemAt: IndexPath(item: 0, section: 1)) as? LatestResultCollectionViewCell
        XCTAssertNotNil(cell1)
        let cell2 = vc.collectionView(vc.collectionView, cellForItemAt: IndexPath(item: 0, section: 2)) as? TeamCircleCollectionViewCell
        XCTAssertNotNil(cell2)
        
        // Test supplementary views (headers)
        let header0 = vc.collectionView(vc.collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 0)) as? SectionHeaderView
        XCTAssertNotNil(header0)
        let header1 = vc.collectionView(vc.collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 1)) as? SectionHeaderView
        XCTAssertNotNil(header1)
        let header2 = vc.collectionView(vc.collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 2)) as? SectionHeaderView
        XCTAssertNotNil(header2)
        
        // willDisplay
        vc.collectionView(vc.collectionView, willDisplay: cell0!, forItemAt: IndexPath(item: 0, section: 0))
        vc.collectionView(vc.collectionView, willDisplay: cell1!, forItemAt: IndexPath(item: 0, section: 1))
        vc.collectionView(vc.collectionView, willDisplay: cell2!, forItemAt: IndexPath(item: 0, section: 2))
        
        // didSelectItemAt
        vc.collectionView(vc.collectionView, didSelectItemAt: IndexPath(item: 0, section: 2))
        
        // Test empty states inside cell methods
        presenter.upcomingEvents = []
        presenter.latestResults = []
        presenter.teams = []
        
        let empty0 = vc.collectionView(vc.collectionView, cellForItemAt: IndexPath(item: 0, section: 0)) as? EmptyStateCollectionViewCell
        XCTAssertNotNil(empty0)
        let empty1 = vc.collectionView(vc.collectionView, cellForItemAt: IndexPath(item: 0, section: 1)) as? EmptyStateCollectionViewCell
        XCTAssertNotNil(empty1)
        let empty2 = vc.collectionView(vc.collectionView, cellForItemAt: IndexPath(item: 0, section: 2)) as? EmptyStateCollectionViewCell
        XCTAssertNotNil(empty2)
        
        // Actions & alert
        vc.favoriteButtonTapped(UIBarButtonItem())
        
        let expectation = self.expectation(description: "alert interaction")
        vc.showSuccessMessage("Success")
        vc.showError(title: "Error", message: "Message")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            vc.perform(Selector(("dismissAlertController")))
            vc.perform(Selector(("resetNotificationIcon")))
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
        
        let skView = LeagueDetailsSkeletonView(frame: .zero)
        skView.startShimmering()
        skView.stopShimmering()
    }
    
    func testTeamDetailsViewController() {
        let mockGetUseCase = MockGetTeamDetailsUseCase()
        let player = Player(
            playerKey: 10,
            playerName: "Player A",
            playerNumber: "7",
            playerImage: nil,
            playerType: "Forward",
            playerAge: "25",
            playerMatchPlayed: nil,
            playerGoals: nil,
            playerYellowCards: nil,
            playerRedCards: nil,
            playerRating: nil
        )
        let team = Team(teamKey: 1, teamName: "Arsenal", teamLogo: nil, playerKey: nil, playerName: nil, playerLogo: nil, playerImage: nil, players: [player])
        mockGetUseCase.result = .success([team])
        
        let vc = TeamDetailsViewController()
        let presenter = TeamDetailsPresenter(
            view: vc,
            getTeamDetailsUseCase: mockGetUseCase,
            teamId: 1,
            sport: "football",
            sportAndLeague: "Football - La Liga"
        )
        vc.presenter = presenter
        
        _ = vc.view
        presenter.viewDidLoad()
        
        let cell = PlayerTableViewCell(style: .default, reuseIdentifier: PlayerTableViewCell.reuseIdentifier)
        XCTAssertNotNil(cell)
        cell.configure(with: player)
        cell.animateCellDisplay(type: .slideInFromLeft)
    }

    func testOnboardingViewController() {
        guard let vc = storyboard.instantiateViewController(withIdentifier: "OnboardingViewController") as? OnboardingViewController else {
            XCTFail("Could not instantiate OnboardingViewController")
            return
        }
        
        let mockSaveFirstEntry = MockSaveFirstEntryUseCase()
        let presenter = OnboardingPresenter(
            view: vc,
            saveFirstEntryUseCase: mockSaveFirstEntry
        )
        vc.presenter = presenter
        
        _ = vc.view
        
        let count = vc.collectionView(vc.collectionView, numberOfItemsInSection: 0)
        XCTAssertEqual(count, 3)
        
        let indexPath = IndexPath(item: 0, section: 0)
        let cell = vc.collectionView(vc.collectionView, cellForItemAt: indexPath) as? OnboardingCollectionViewCell
        XCTAssertNotNil(cell)
        
        let size = vc.collectionView(vc.collectionView, layout: vc.collectionView.collectionViewLayout, sizeForItemAt: indexPath)
        XCTAssertTrue(size.width >= 0)
        
        let scrollView = UIScrollView(frame: vc.collectionView.frame)
        scrollView.contentOffset = CGPoint(x: vc.collectionView.frame.width, y: 0)
        vc.scrollViewDidEndDecelerating(scrollView)
        
        vc.nextButtonClicked(UIButton())
        vc.prevButtonClicked(UIButton())
        vc.getStartedButtonClicked(UIButton())
        vc.skipButtonClicked(UIButton())
        
        vc.navigateToHome()
    }
    
    func testSplashVideoViewController() {
        let vc = SplashVideoViewController()
        var finished = false
        vc.onVideoFinished = {
            finished = true
        }
        _ = vc.view
        vc.viewDidLayoutSubviews()
        vc.perform(Selector(("videoDidFinish")))
        
        let expectation = self.expectation(description: "video finishes async")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(finished)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testSectionHeaderView() {
        let header = Bundle(for: SectionHeaderView.self).loadNibNamed("SectionHeaderView", owner: nil, options: nil)?.first as? SectionHeaderView
        XCTAssertNotNil(header)
        header?.awakeFromNib()
    }
}

