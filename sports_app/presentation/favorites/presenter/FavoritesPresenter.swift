//
//  FavoritesPresenter.swift
//  sports_app
//
//  Created by Thaowpsta Saiid on 25/05/2026.
//

import Foundation
import UIKit

class FavoritesPresenter: FavoritesPresenterProtocol {
    private weak var view: FavoritesViewProtocol?
    private let getFavoritesUseCase: GetFavoritesUseCaseProtocol
    private let removeFavoriteUseCase: RemoveFavoriteUseCaseProtocol

    private var favoriteLeagues: [League] = []
    private var filteredFavorites: [League] = []
    private let filterOptions = ["All", "football", "basketball", "tennis", "cricket"]
    private var currentFilterIndex = 0

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
            applyCurrentFilter()
        } catch {
            view?.displayError(
                "Failed to fetch favorites: \(error.localizedDescription)"
            )
        }
    }

    func filterFavorites(by index: Int) {
            currentFilterIndex = index
            applyCurrentFilter()
        }
        
    private func applyCurrentFilter() {
        if currentFilterIndex == 0 {
            filteredFavorites = favoriteLeagues
        } else {
            let selectedSport = filterOptions[currentFilterIndex]
            
            print("🔍 Segment tapped! We are looking for: '\(selectedSport)'")
            for league in favoriteLeagues {
                print("   - Saved League: '\(league.leagueName ?? "Unknown")' | Sport in DB: '\(league.sportName ?? "NIL")'")
            }

            filteredFavorites = favoriteLeagues.filter {
                // Added .trimmingCharacters to ignore hidden spaces!
                let dbSport = $0.sportName?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() ?? ""
                return dbSport == selectedSport.lowercased()
            }
        }
            
        if filteredFavorites.isEmpty {
            view?.showEmptyState()
        } else {
            view?.displayFavorites()
        }
    }

    func getLeaguesCount() -> Int {
        return filteredFavorites.count
    }

    func configureCell(_ cell: LeagueTableViewCell, at index: Int) {
        guard index >= 0 && index < filteredFavorites.count else { return }
        
        let league = filteredFavorites[index]

        cell.displayLeagueName(league.leagueName ?? "Unknown League")
        cell.displayLeagueCountry(league.leagueCountry ?? "Unknown Country")

        if let logoUrl = league.leagueLogo {
            cell.displayLeagueBadge(from: logoUrl)
        }
    }

    func removeFavorite(at index: Int) {
        guard index >= 0 && index < filteredFavorites.count else { return }
        
        let league = filteredFavorites[index]

        guard let leagueKey = league.leagueKey else {
            view?.displayError("Unable to remove: Invalid League ID.")
            return
        }

        do {
            try removeFavoriteUseCase.execute(leagueKey: leagueKey)

            filteredFavorites.remove(at: index)
            favoriteLeagues.removeAll { $0.leagueKey == leagueKey }
            
            if filteredFavorites.isEmpty {
                view?.showEmptyState()
            } else {
                view?.displayFavorites()
            }

        } catch {
            view?.displayError("Failed to remove favorite: \(error.localizedDescription)")
        }
    }
    
    func didSelectFavorite(at index: Int) {
            let selectedLeague = filteredFavorites[index]
            
        view?.navigateToLeagueDetails(with: selectedLeague, sportName: selectedLeague.sportName ?? "football")
        }
}
