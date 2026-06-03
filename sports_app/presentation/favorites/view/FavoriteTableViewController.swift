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

    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)

        presenter.didSelectFavorite(at: indexPath.row)
    }
}

extension FavoriteTableViewController: FavoritesViewProtocol {
    func displayFavorites() {
        self.tableView.backgroundView = nil
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func displayError(_ message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Error",
                message: message,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }

    func showEmptyState() {
        DispatchQueue.main.async {
            self.tableView.backgroundView = self.createEmptyStateView()
            self.tableView.reloadData()
        }
    }

    private func createEmptyStateView() -> UIView {
        let emptyView = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: tableView.bounds.width,
                height: tableView.bounds.height
            )
        )

        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "heart.slash.fill")
        imageView.tintColor = UIColor(
            red: 51.0 / 255.0,
            green: 51.0 / 255.0,
            blue: 51.0 / 255.0,
            alpha: 1.0
        )
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        let messageLabel = UILabel()
        messageLabel.text =
            "No favorites saved yet. Go to league details to add favorites."
        messageLabel.textColor = UIColor(
            red: 136.0 / 255.0,
            green: 136.0 / 255.0,
            blue: 136.0 / 255.0,
            alpha: 1.0
        )
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 13)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        emptyView.addSubview(imageView)
        emptyView.addSubview(messageLabel)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(
                equalTo: emptyView.centerXAnchor
            ),
            imageView.centerYAnchor.constraint(
                equalTo: emptyView.centerYAnchor,
                constant: -40
            ),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),

            messageLabel.topAnchor.constraint(
                equalTo: imageView.bottomAnchor,
                constant: 16
            ),
            messageLabel.leadingAnchor.constraint(
                equalTo: emptyView.leadingAnchor,
                constant: 24
            ),
            messageLabel.trailingAnchor.constraint(
                equalTo: emptyView.trailingAnchor,
                constant: -24
            ),
        ])

        return emptyView
    }

    func navigateToLeagueDetails(with league: League, sportName: String) {
            // Run on main thread to ensure smooth UI transition
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                guard
                    let detailsVC = storyboard.instantiateViewController(
                        withIdentifier: "LeagueDetailsViewController"
                    ) as? LeagueDetailsViewController
                else {
                    print("❌ Could not find LeagueDetailsViewController in Storyboard")
                    return
                }

                let repository = LeagueDetailsRepository(sport: sportName)
                let favoriteRepository = FavoriteLeaguesRepository()

                let upcomingUseCase = GetUpcomingEventsUseCase(repository: repository)
                let latestUseCase = GetLatestResultsUseCase(repository: repository)
                let teamsUseCase = GetTeamsUseCase(repository: repository)

                let detailsPresenter = LeagueDetailsPresenter(
                    view: detailsVC,
                    league: league,
                    sport: sportName,
                    favoriteRepository: favoriteRepository,
                    getUpcomingUseCase: upcomingUseCase,
                    getLatestUseCase: latestUseCase,
                    getTeamsUseCase: teamsUseCase
                )

                detailsVC.presenter = detailsPresenter

                // Debug print to check if Navigation Controller exists
                if self.navigationController == nil {
                    print("⚠️ WARNING: navigationController is nil. Cannot push view.")
                }

                self.navigationController?.pushViewController(detailsVC, animated: true)
            }
        }
}
