//
//  LeaguesViewProtocol.swift
//  sports_app
//
//  Created by Thaowpsta Saiid on 23/05/2026.
//

import Foundation

protocol LeaguesViewProtocol: AnyObject {
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func reloadTableView()
    func showError(message: String)
    func navigateToLeagueDetails(with league: League, sportName: String)
}

protocol LeaguesPresenterProtocol {
    func viewDidLoad()
    func getLeaguesCount() -> Int
    func configureCell(_ cell: LeagueCellViewProtocol, at index: Int)
    func didSelectRow(at index: Int)
}

protocol LeagueCellViewProtocol {
    func displayLeagueName(_ name: String)
    func displayLeagueBadge(from urlString: String)
    func displayLeagueCountry(_ country: String)
}
