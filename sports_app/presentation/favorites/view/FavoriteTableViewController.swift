//
//  FavoriteTableViewController.swift
//  sports_app
//
//  Created by Thaowpsta Saiid on 25/05/2026.
//

import UIKit

class FavoriteTableViewController: UITableViewController {

    var presenter: FavoritesPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Favorites"
        setupTableView()

        let repo = FavoriteLeaguesRepository()
        let getUseCase = GetFavoritesUseCase(repository: repo)
        let removeUseCase = RemoveFavoriteUseCase(repository: repo)
        let addUseCase = AddFavoriteUseCase(repository: repo)

        let dummyLeague = League(
            leagueKey: 12345,
            leagueName: "Test League",
            leagueLogo: nil,
            leagueCountry: "Egypt"
        )
        
        //        do {
        //            try addUseCase.execute(league: dummyLeague)
        //            print("✅ Dummy league added successfully!")
        //        } catch {
        //            print("❌ Failed to add dummy league: \(error)")
        //        }

        do {
            try removeUseCase.execute(leagueKey: 12345)
            print("✅ Dummy league Removed successfully!")
        } catch {
            print("❌ Failed to remove dummy league: \(error)")
        }

        presenter = FavoritesPresenter(
            view: self,
            getFavoritesUseCase: getUseCase,
            removeFavoriteUseCase: removeUseCase
        )

        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }

    private func setupTableView() {
        tableView.separatorStyle = .none
        let cellNib = UINib(nibName: "LeagueTableViewCell", bundle: nil)
        tableView.register(
            cellNib,
            forCellReuseIdentifier: "LeagueTableViewCell"
        )
    }

    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return presenter.getLeaguesCount()
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "LeagueTableViewCell",
                for: indexPath
            ) as? LeagueTableViewCell
        else {
            return UITableViewCell()
        }

        presenter.configureCell(cell, at: indexPath.row)
        return cell
    }

    // Enable swipe to delete for favorites
    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            presenter.removeFavorite(at: indexPath.row)
        }
    }
}

extension FavoriteTableViewController: FavoritesViewProtocol {
    func displayFavorites() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func displayError(_ message: String) {
        // Show an alert controller
    }

    func showEmptyState() {
        // Show a placeholder view or empty table
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
