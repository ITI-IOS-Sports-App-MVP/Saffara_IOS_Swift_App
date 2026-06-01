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

//        let dummyLeague = League(
//            leagueKey: 12345,
//            leagueName: "Test League",
//            leagueLogo: nil,
//            leagueCountry: "Egypt"
//        )
//
//                do {
//                    try addUseCase.execute(league: dummyLeague)
//                    print("✅ Dummy league added successfully!")
//                } catch {
//                    print("❌ Failed to add dummy league: \(error)")
//                }

//        do {
//            try removeUseCase.execute(leagueKey: 12345)
//            print("✅ Dummy league Removed successfully!")
//        } catch {
//            print("❌ Failed to remove dummy league: \(error)")
//        }

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
        imageView.tintColor = UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        let messageLabel = UILabel()
        messageLabel.text =
            "No favorites saved yet. Go to league details to add favorites."
        messageLabel.textColor = UIColor(red: 136.0/255.0, green: 136.0/255.0, blue: 136.0/255.0, alpha: 1.0)
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
}
