//
//  LeaguesPresenter.swift
//  sports_app
//
//  Created by Thaowpsta Saiid on 23/05/2026.
//


import Foundation

class LeaguesPresenter: LeaguesPresenterProtocol {
    private weak var view: LeaguesViewProtocol?
    private let getLeaguesUseCase: GetLeaguesUseCaseProtocol
    private let sportName: String
    private var leaguesList: [League] = []
    
    init(view: LeaguesViewProtocol, getLeaguesUseCase: GetLeaguesUseCaseProtocol, sportName: String) {
        self.view = view
        self.getLeaguesUseCase = getLeaguesUseCase
        self.sportName = sportName
    }
    
    func viewDidLoad() {
        view?.showLoadingIndicator()
        getLeaguesUseCase.execute(sportName: sportName) { [weak self] result in
            guard let self = self else { return }
            self.view?.hideLoadingIndicator()
            
            switch result {
            case .success(let leagues):
                self.leaguesList = leagues
                self.view?.reloadTableView()
            case .failure(let error):
                self.view?.showError(message: error.localizedDescription)
            }
        }
    }
    
    func getLeaguesCount() -> Int {
        return leaguesList.count
    }
    
    func configureCell(_ cell: LeagueCellViewProtocol, at index: Int) {
        let league = leaguesList[index]
        cell.displayLeagueName(league.leagueName ?? "Unknown League")
        cell.displayLeagueBadge(from: league.leagueLogo ?? "")
        cell.displayLeagueCountry(league.leagueCountry ?? "Unknown Country")
    }
    
    func didSelectRow(at index: Int) {
        let selectedLeague = leaguesList[index]
        print("Navigate to details for \(selectedLeague.leagueName ?? "")")
    }
}
