//
//  FavoritesPresenter.swift
//  sports_app
//
//  Created by Thaowpsta Saiid on 25/05/2026.
//

import Foundation

class FavoritesPresenter: FavoritesPresenterProtocol {
    private weak var view: FavoritesViewProtocol?
    private let getFavoritesUseCase: GetFavoritesUseCaseProtocol
    private let removeFavoriteUseCase: RemoveFavoriteUseCaseProtocol

    private var favoriteLeagues: [League] = []

    init(
        view: FavoritesViewProtocol,
        getFavoritesUseCase: GetFavoritesUseCaseProtocol,
        removeFavoriteUseCase: RemoveFavoriteUseCaseProtocol
    ) {
        self.view = view
        self.getFavoritesUseCase = getFavoritesUseCase
        self.removeFavoriteUseCase = removeFavoriteUseCase
    }

    func viewDidLoad() {
        fetchFavorites()
    }

    func viewWillAppear() {
        fetchFavorites()
    }

    private func fetchFavorites() {
        do {
            favoriteLeagues = try getFavoritesUseCase.execute()
            if favoriteLeagues.isEmpty {
                view?.showEmptyState()
            } else {
                view?.displayFavorites()
            }
        } catch {
            view?.displayError(
                "Failed to fetch favorites: \(error.localizedDescription)"
            )
        }
    }

    func getLeaguesCount() -> Int {
        return favoriteLeagues.count
    }

    func configureCell(_ cell: LeagueTableViewCell, at index: Int) {
        let league = favoriteLeagues[index]

        cell.displayLeagueName(league.leagueName ?? "Unknown League")

        cell.displayLeagueCountry(league.leagueCountry ?? "Unknown Country")

        if let logoUrl = league.leagueLogo {
            cell.displayLeagueBadge(from: logoUrl)
        } else {
            // cell.leagueImageView.image = UIImage(named: "placeholder")
        }
    }

    func removeFavorite(at index: Int) {
        let league = favoriteLeagues[index]

        // Ensure we have a valid ID before attempting to delete
        guard let leagueKey = league.leagueKey else {
            view?.displayError("Unable to remove: Invalid League ID.")
            return
        }

        do {
            try removeFavoriteUseCase.execute(leagueKey: leagueKey)

            favoriteLeagues.remove(at: index)

            view?.displayFavorites()

            if favoriteLeagues.isEmpty {
                view?.showEmptyState()
            }

        } catch {
            view?.displayError(
                "Failed to remove favorite: \(error.localizedDescription)"
            )
        }
    }
}
