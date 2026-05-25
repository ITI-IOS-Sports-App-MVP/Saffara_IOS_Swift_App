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
}

protocol FavoritesPresenterProtocol {
    func viewDidLoad()
    func viewWillAppear()
    func getLeaguesCount() -> Int
    func configureCell(_ cell: LeagueTableViewCell, at index: Int)
    func removeFavorite(at index: Int)
}
