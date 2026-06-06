//
//  FavoriteTableViewController.swift
//  sports_app
//
//  Created by Thaowpsta Saiid on 25/05/2026.
//

import UIKit
import Swinject

class FavoriteTableViewController: UITableViewController {

    @IBOutlet weak var filterSegmentedControl: UISegmentedControl!
    
    var presenter: FavoritesPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "tab_favorites".localized

        let container = AppDIContainer.shared.container
        let getUseCase = container.resolve(GetFavoritesUseCaseProtocol.self)!
        let removeUseCase = container.resolve(RemoveFavoriteUseCaseProtocol.self)!

        presenter = FavoritesPresenter(
            view: self,
            getFavoritesUseCase: getUseCase,
            removeFavoriteUseCase: removeUseCase
        )

        setupTableView()
        setupSegmentedControl()
        
        presenter.viewDidLoad()
    }

    private func setupSegmentedControl() {
        filterSegmentedControl.setTitle("filter_all".localized, forSegmentAt: 0)
        filterSegmentedControl.setTitle("sport_soccer".localized, forSegmentAt: 1)
        filterSegmentedControl.setTitle("sport_basketball".localized, forSegmentAt: 2)
        filterSegmentedControl.setTitle("sport_tennis".localized, forSegmentAt: 3)
        filterSegmentedControl.setTitle("cricket".localized, forSegmentAt: 4)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    @objc private func filterSegmentChanged(_ sender: UISegmentedControl) {
        presenter.filterFavorites(by: sender.selectedSegmentIndex)
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
            
            guard NetworkMonitor.shared.isConnected else {
                let offlineAlert = UIAlertController(
                    title: "error_title".localized,
                    message: "error_no_internet_delete".localized,
                    preferredStyle: .alert
                )
                offlineAlert.addAction(UIAlertAction(title: "ok".localized, style: .default))
                
                self.present(offlineAlert, animated: true)
                
                tableView.reloadRows(at: [indexPath], with: .automatic)
                return
            }
            
            let alert = UIAlertController(
                title: "remove_favorite_title".localized,
                message: "remove_favorite_message".localized,
                preferredStyle: .alert
            )
            
            let cancelAction = UIAlertAction(title: "cancel".localized, style: .cancel) { _ in
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            
            let deleteAction = UIAlertAction(title: "delete".localized, style: .destructive) { [weak self] _ in
                self?.presenter.removeFavorite(at: indexPath.row)
            }
            
            alert.addAction(cancelAction)
            alert.addAction(deleteAction)
            
            self.present(alert, animated: true, completion: nil)
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
        let updateUI = {
            self.tableView.backgroundView = nil
            self.tableView.reloadData()
        }
        
        if Thread.isMainThread {
            updateUI()
        } else {
            DispatchQueue.main.async {
                updateUI()
            }
        }
    }

    func displayError(_ message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "error_title".localized,
                message: message,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "ok_button".localized, style: .default))
            self.present(alert, animated: true)
        }
    }

    func showEmptyState() {
        let updateUI = {
            self.tableView.backgroundView = self.createEmptyStateView()
            self.tableView.reloadData()
        }
        
        if Thread.isMainThread {
            updateUI()
        } else {
            DispatchQueue.main.async {
                updateUI()
            }
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
        messageLabel.text = "empty_favorites".localized
        
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

                let container = AppDIContainer.shared.container
                let repository = container.resolve(LeagueDetailsRepoProtocol.self, argument: sportName)!
                let favoriteRepository = container.resolve(FavoriteLeaguesRepoProtocol.self)!

                let upcomingUseCase = container.resolve(GetUpcomingEventsUseCaseProtocol.self, argument: repository)!
                let latestUseCase = container.resolve(GetLatestResultsUseCaseProtocol.self, argument: repository)!
                let teamsUseCase = container.resolve(GetTeamsUseCaseProtocol.self, argument: repository)!

                let scheduleAlertUseCase = container.resolve(ScheduleAlertUseCaseProtocol.self)!
                
                let detailsPresenter = LeagueDetailsPresenter(
                    view: detailsVC,
                    league: league,
                    sport: sportName,
                    favoriteRepository: favoriteRepository,
                    getUpcomingUseCase: upcomingUseCase,
                    getLatestUseCase: latestUseCase,
                    getTeamsUseCase: teamsUseCase,
                    scheduleAlertUseCase: scheduleAlertUseCase
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
