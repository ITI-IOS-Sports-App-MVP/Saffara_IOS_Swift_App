//
//  LeagueDetailsPresenter.swift
//  sports_app
//
//  Created by Thaowpsta Saiid on 30/05/2026.
//

import Foundation
import Combine

class LeagueDetailsPresenter {
    private weak var view: LeagueDetailsViewProtocol?
    let favoriteRepository: FavoriteLeaguesRepoProtocol
    private let getUpcomingUseCase: GetUpcomingEventsUseCaseProtocol
    private let getLatestUseCase: GetLatestResultsUseCaseProtocol
    private let getTeamsUseCase: GetTeamsUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()
    
    var league: League
    var isFavorite: Bool = false
    
    var upcomingEvents: [Event] = []
    var latestResults: [Event] = []
    var teams: [Team] = []
    
    let sport: String
    
    init(view: LeagueDetailsViewProtocol,
         league: League,
         sport: String,
         favoriteRepository: FavoriteLeaguesRepoProtocol,
         getUpcomingUseCase: GetUpcomingEventsUseCaseProtocol,
         getLatestUseCase: GetLatestResultsUseCaseProtocol,
         getTeamsUseCase: GetTeamsUseCaseProtocol) {
        
        self.view = view
        self.league = league
        self.sport = sport
        self.favoriteRepository = favoriteRepository
        self.getUpcomingUseCase = getUpcomingUseCase
        self.getLatestUseCase = getLatestUseCase
        self.getTeamsUseCase = getTeamsUseCase
    }
    
    func viewDidLoad() {
        view?.showLoadingIndicator()
        
        Publishers.Zip3(
            getUpcomingUseCase.execute(leagueKey: league.leagueKey ?? 0)
                .catch { _ in Just([]) },
            getLatestUseCase.execute(leagueKey: league.leagueKey ?? 0)
                .catch { _ in Just([]) },
            getTeamsUseCase.execute(leagueKey: league.leagueKey ?? 0)
                .catch { _ in Just([]) }
        )
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { [weak self] _ in
            self?.view?.hideLoadingIndicator()
            self?.view?.displayUpcomingEvents()
            self?.view?.displayLatestResults()
            self?.view?.displayTeams()
        }, receiveValue: { [weak self] upcoming, latest, teams in
            self?.upcomingEvents = upcoming
            self?.latestResults = latest
            self?.teams = teams
        })
        .store(in: &cancellables)
        
        checkFavoriteStatus()
    }
    
    func viewWillAppear() {
        checkFavoriteStatus()
    }
    
    private func checkFavoriteStatus() {
            self.isFavorite = favoriteRepository.isFavorite(leagueKey: league.leagueKey ?? 0)
            view?.updateFavoriteIcon(isFavorite: self.isFavorite)
        }
    
    func getUpcomingEvent(at index: Int) -> Event { return upcomingEvents[index] }
    func getLatestResult(at index: Int) -> Event { return latestResults[index] }
    func getTeam(at index: Int) -> Team { return teams[index] }
    func favoriteButtonTapped() {
        
        guard NetworkMonitor.shared.isConnected else {
            view?.showError(title: "error_title".localized, message: "error_failed_update_favorites".localized)
            return
        }
        
        do{
            if isFavorite {
                try favoriteRepository.removeLeagueFromFavorites(leagueKey: league.leagueKey ?? 0)
            } else {
                league.sportName = self.sport
                try favoriteRepository.addLeagueToFavorites(league: league)
            }
            
            isFavorite.toggle()
            view?.updateFavoriteIcon(isFavorite: isFavorite)
        }catch{
            view?.showError(title: "error_title".localized, message: "error_failed_update_favorites".localized + error.localizedDescription)
        }
    }
            
}
