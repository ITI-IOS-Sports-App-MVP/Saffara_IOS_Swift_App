//
//  FavoritesViewProtocol.swift
//  sports_app
//
//  Created by Thaowpsta Saiid on 25/05/2026.
//


protocol FavoritesViewProtocol: AnyObject {
    func displayFavorites()
    func displayError(_ message: String)
    func showEmptyState()
    func navigateToLeagueDetails(with league: League, sportName: String)
}

protocol FavoritesPresenterProtocol {
    func viewDidLoad()
    func viewWillAppear()
    func getLeaguesCount() -> Int
    func configureCell(_ cell: LeagueTableViewCell, at index: Int)
    func removeFavorite(at index: Int)
    func didSelectFavorite(at index: Int)
    func filterFavorites(by index: Int)
}
