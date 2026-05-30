//
//  LeagueDetailsPresenter.swift
//  sports_app
//
//  Created by Thaowpsta Saiid on 30/05/2026.
//

import Foundation

class LeagueDetailsPresenter {
    private weak var view: LeagueDetailsViewProtocol?
    private let getUpcomingUseCase: GetUpcomingEventsUseCaseProtocol
    private let getLatestUseCase: GetLatestResultsUseCaseProtocol
    private let getTeamsUseCase: GetTeamsUseCaseProtocol
    
    let leagueId: Int
    
    var upcomingEvents: [Event] = []
    var latestResults: [Event] = []
    var teams: [Team] = []
    
    init(view: LeagueDetailsViewProtocol,
         leagueId: Int,
         getUpcomingUseCase: GetUpcomingEventsUseCaseProtocol,
         getLatestUseCase: GetLatestResultsUseCaseProtocol,
         getTeamsUseCase: GetTeamsUseCaseProtocol) {
        
        self.view = view
        self.leagueId = leagueId
        self.getUpcomingUseCase = getUpcomingUseCase
        self.getLatestUseCase = getLatestUseCase
        self.getTeamsUseCase = getTeamsUseCase
    }
    
    func viewDidLoad() {
        view?.showLoadingIndicator()
        
        let group = DispatchGroup()
        
        group.enter()
        getUpcomingUseCase.execute(leagueId: leagueId) { [weak self] result in
            if case .success(let events) = result { self?.upcomingEvents = events }
            group.leave()
        }
        
        group.enter()
        getLatestUseCase.execute(leagueId: leagueId) { [weak self] result in
            if case .success(let events) = result { self?.latestResults = events }
            group.leave()
        }
        
        group.enter()
        getTeamsUseCase.execute(leagueId: leagueId) { [weak self] result in
            if case .success(let teams) = result { self?.teams = teams }
            group.leave()
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.view?.hideLoadingIndicator()
            self?.view?.displayUpcomingEvents()
            self?.view?.displayLatestResults()
            self?.view?.displayTeams()
        }
    }
    
    func getUpcomingEvent(at index: Int) -> Event { return upcomingEvents[index] }
    func getLatestResult(at index: Int) -> Event { return latestResults[index] }
    func getTeam(at index: Int) -> Team { return teams[index] }
}
