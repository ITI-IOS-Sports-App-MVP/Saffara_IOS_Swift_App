//
//  LeagueDetailsPresenter.swift
//  sports_app
//
//  Created by Thaowpsta Saiid on 30/05/2026.
//

import Foundation

class LeagueDetailsPresenter {
    private weak var view: LeagueDetailsViewProtocol?
    let favoriteRepository: FavoriteLeaguesRepoProtocol
    private let getUpcomingUseCase: GetUpcomingEventsUseCaseProtocol
    private let getLatestUseCase: GetLatestResultsUseCaseProtocol
    private let getTeamsUseCase: GetTeamsUseCaseProtocol
    
    let league: League
    var isFavorite: Bool = false
    
    var upcomingEvents: [Event] = []
    var latestResults: [Event] = []
    var teams: [Team] = []
    
    init(view: LeagueDetailsViewProtocol,
         league: League,
         favoriteRepository: FavoriteLeaguesRepository,
         getUpcomingUseCase: GetUpcomingEventsUseCaseProtocol,
         getLatestUseCase: GetLatestResultsUseCaseProtocol,
         getTeamsUseCase: GetTeamsUseCaseProtocol) {
        
        self.view = view
        self.league = league
        self.favoriteRepository = favoriteRepository
        self.getUpcomingUseCase = getUpcomingUseCase
        self.getLatestUseCase = getLatestUseCase
        self.getTeamsUseCase = getTeamsUseCase
    }
    
    func viewDidLoad() {
        view?.showLoadingIndicator()
        
        let group = DispatchGroup()
        
        group.enter()
        getUpcomingUseCase.execute(leagueKey: league.leagueKey ?? 0) { [weak self] result in
            if case .success(let events) = result { self?.upcomingEvents = events }
            group.leave()
        }
        
        group.enter()
        getLatestUseCase.execute(leagueKey: league.leagueKey ?? 0) { [weak self] result in
            if case .success(let events) = result { self?.latestResults = events }
            group.leave()
        }
        
        group.enter()
        getTeamsUseCase.execute(leagueKey: league.leagueKey ?? 0) { [weak self] result in
            if case .success(let teams) = result { self?.teams = teams }
            group.leave()
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.view?.hideLoadingIndicator()
            self?.view?.displayUpcomingEvents()
            self?.view?.displayLatestResults()
            self?.view?.displayTeams()
        }
        
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
        do{
            if isFavorite {
                try favoriteRepository.removeLeagueFromFavorites(leagueKey: league.leagueKey ?? 0)
            } else {
                try favoriteRepository.addLeagueToFavorites(league: league)
            }
            
            isFavorite.toggle()
            view?.updateFavoriteIcon(isFavorite: isFavorite)
        }catch{
            view?.showError(message: "Failed to update favorites: /(error.localizedDescription)")
        }
        }
            
}
