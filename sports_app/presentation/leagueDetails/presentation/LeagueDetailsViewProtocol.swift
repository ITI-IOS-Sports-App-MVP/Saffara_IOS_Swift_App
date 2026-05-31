//
//  LeagueDetailsViewProtocol.swift
//  sports_app
//
//  Created by Thaowpsta Saiid on 30/05/2026.
//


protocol LeagueDetailsViewProtocol: AnyObject {
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func displayUpcomingEvents()
    func displayLatestResults()
    func displayTeams()
    func showError(message: String)
    func updateFavoriteIcon(isFavorite: Bool)
}
