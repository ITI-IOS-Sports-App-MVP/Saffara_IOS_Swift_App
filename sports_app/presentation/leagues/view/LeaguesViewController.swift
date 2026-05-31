//
//  LeaguesViewController.swift
//  sports_app
//
//  Created by Thaowpsta Saiid on 23/05/2026.
//

import UIKit

class LeaguesViewController: UITableViewController, LeaguesViewProtocol {

    var presenter: LeaguesPresenterProtocol!

    private var activityIndicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Leagues"

        setupTableView()
        setupLoadingIndicator()

        presenter.viewDidLoad()
    }

    private func setupTableView() {

        tableView.separatorStyle = .none

        let cellNib = UINib(nibName: "LeagueTableViewCell", bundle: nil)
        tableView.register(
            cellNib,
            forCellReuseIdentifier: "LeagueTableViewCell"
        )
    }

    private func setupLoadingIndicator() {
        activityIndicator.hidesWhenStopped = true

        let backgroundView = UIView(frame: tableView.bounds)
        activityIndicator.center = backgroundView.center
        backgroundView.addSubview(activityIndicator)

        tableView.backgroundView = backgroundView
    }

    func showLoadingIndicator() {
        activityIndicator.startAnimating()
    }

    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }

    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func showError(message: String) {
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

    func navigateToLeagueDetails(with league: League, sportName: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard
            let detailsVC = storyboard.instantiateViewController(
                withIdentifier: "LeagueDetailsViewController"
            ) as? LeagueDetailsViewController
        else {
            print("Could not find LeagueDetailsViewController")
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
            favoriteRepository: favoriteRepository,
            getUpcomingUseCase: upcomingUseCase,
            getLatestUseCase: latestUseCase,
            getTeamsUseCase: teamsUseCase
        )

        detailsVC.presenter = detailsPresenter

        self.navigationController?.pushViewController(detailsVC, animated: true)
    }

    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return presenter?.getLeaguesCount() ?? 0
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

    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        presenter.didSelectRow(at: indexPath.row)
    }
}
