//
//  LeaguesPresenter.swift
//  sports_app
//
//  Created by Thaowpsta Saiid on 23/05/2026.
//

import Foundation
import Combine

class LeaguesPresenter: LeaguesPresenterProtocol {
    private weak var view: LeaguesViewProtocol?
    private let getLeaguesUseCase: GetLeaguesUseCaseProtocol
    private let sportName: String
    private var leaguesList: [League] = []
    private var cancellables = Set<AnyCancellable>()

    init(
        view: LeaguesViewProtocol,
        getLeaguesUseCase: GetLeaguesUseCaseProtocol,
        sportName: String
    ) {
        self.view = view
        self.getLeaguesUseCase = getLeaguesUseCase
        self.sportName = sportName
    }

    func viewDidLoad() {
        view?.showLoadingIndicator()
        
        getLeaguesUseCase.execute(sportName: sportName)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.view?.hideLoadingIndicator()
                if case .failure(let error) = completion {
                    self.view?.showError(message: error.localizedDescription)
                }
            }, receiveValue: { [weak self] leagues in
                guard let self = self else { return }
                self.leaguesList = leagues
                self.view?.reloadTableView()
            })
            .store(in: &cancellables)
    }

    func getLeaguesCount() -> Int {
        return leaguesList.count
    }

    func configureCell(_ cell: LeagueCellViewProtocol, at index: Int) {
        let league = leaguesList[index]
        print(league)
        cell.displayLeagueName(league.leagueName ?? "Unknown League")
        cell.displayLeagueBadge(from: league.leagueLogo ?? "")
        cell.displayLeagueCountry(league.leagueCountry ?? "Unknown Country")
    }

    func didSelectRow(at index: Int) {
        let selectedLeague = leaguesList[index]

        view?.navigateToLeagueDetails(
            with: selectedLeague,
            sportName: self.sportName
        )
    }
}
