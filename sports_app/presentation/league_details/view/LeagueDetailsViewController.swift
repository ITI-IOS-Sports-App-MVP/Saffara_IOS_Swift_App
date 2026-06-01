//
//  LeagueDetailsViewController.swift
//  sports_app
//
//  Created by Thaowpsta Saiid on 29/05/2026.
//

import UIKit

class LeagueDetailsViewController: UICollectionViewController,
    LeagueDetailsViewProtocol
{

    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    var presenter: LeagueDetailsPresenter!

    private var activityIndicator = UIActivityIndicatorView(style: .large)

    enum Section: Int, CaseIterable {
        case upcomingEvents = 0
        case latestResults = 1
        case teams = 2
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupLoadingIndicator()
        presenter.viewDidLoad()
    }

    @IBAction func favoriteButtonTapped(_ sender: Any) {
        presenter.favoriteButtonTapped()
    }

    private func setupCollectionView() {
        collectionView.collectionViewLayout = createCompositionalLayout()

        collectionView.register(
            UINib(nibName: "EventCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "EventCell"
        )
        collectionView.register(
            UINib(nibName: "LatestResultCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "LatestResultCell"
        )
        collectionView.register(
            UINib(nibName: "TeamCircleCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "TeamCircleCell"
        )
        collectionView.register(
            EmptyStateCollectionViewCell.self,
            forCellWithReuseIdentifier: "EmptyStateCell"
        )

        let headerNib = UINib(nibName: "SectionHeaderView", bundle: nil)
        collectionView.register(
            headerNib,
            forSupplementaryViewOfKind: UICollectionView
                .elementKindSectionHeader,
            withReuseIdentifier: "HeaderView"
        )
    }

    private func setupLoadingIndicator() {
        activityIndicator.hidesWhenStopped = true

        let backgroundView = UIView(frame: collectionView.bounds)
        activityIndicator.center = backgroundView.center
        backgroundView.addSubview(activityIndicator)

        collectionView.backgroundView = backgroundView
    }

    func showLoadingIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
    }

    func hideLoadingIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }

    func displayUpcomingEvents() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    func displayLatestResults() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    func displayTeams() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
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

    func updateFavoriteIcon(isFavorite: Bool) {
        let iconName = isFavorite ? "heart.fill" : "heart"
        favoriteButton.image = UIImage(systemName: iconName)

        UIView.transition(
            with: self.navigationController?.navigationBar ?? self.view,
            duration: 0.2,
            options: .transitionCrossDissolve,
            animations: nil,
            completion: nil
        )
    }

    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        guard let sectionType = Section(rawValue: section) else { return 0 }
        switch sectionType {
        case .upcomingEvents: return presenter.upcomingEvents.isEmpty ? 1 : presenter.upcomingEvents.count
        case .latestResults: return presenter.latestResults.count
        case .teams: return presenter.teams.count
        }
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let sectionType = Section(rawValue: indexPath.section) else {
            return UICollectionViewCell()
        }

        switch sectionType {
        case .upcomingEvents:
            if presenter.upcomingEvents.isEmpty {
                let cell =
                    collectionView.dequeueReusableCell(
                        withReuseIdentifier: "EmptyStateCell",
                        for: indexPath
                    ) as! EmptyStateCollectionViewCell
                cell.configure(
                    message: "No Upcoming Events",
                    systemImageName: "calendar.badge.exclamationmark"
                )
                return cell
            }
            let cell =
                collectionView.dequeueReusableCell(
                    withReuseIdentifier: "EventCell",
                    for: indexPath
                ) as! EventCollectionViewCell
            let event = presenter.getUpcomingEvent(at: indexPath.row)
            cell.configure(
                homeImage: event.displayHomeLogo ?? "",
                awayImage: event.displayAwayLogo ?? "",
                name: "\(event.displayHomeName) vs \(event.displayAwayName)",
                date: event.displayDate
            )
            return cell

        case .latestResults:
            if presenter.latestResults.isEmpty {
                let cell =
                    collectionView.dequeueReusableCell(
                        withReuseIdentifier: "EmptyStateCell",
                        for: indexPath
                    ) as! EmptyStateCollectionViewCell
                cell.configure(
                    message: "No Latest Results Available",
                    systemImageName: "clock.badge.exclamationmark"
                )
                return cell
            }

            let cell =
                collectionView.dequeueReusableCell(
                    withReuseIdentifier: "LatestResultCell",
                    for: indexPath
                ) as! LatestResultCollectionViewCell
            let event = presenter.getLatestResult(at: indexPath.row)

            cell.configure(
                homeImage: event.displayHomeLogo,
                homeName: event.displayHomeName,
                homeScore: event.displayHomeScore,
                awayImage: event.displayAwayLogo,
                awayName: event.displayAwayName,
                awayScore: event.displayAwayScore,
                status: event.displayDate
            )
            return cell

        case .teams:
            if presenter.teams.isEmpty {
                let cell =
                    collectionView.dequeueReusableCell(
                        withReuseIdentifier: "EmptyStateCell",
                        for: indexPath
                    ) as! EmptyStateCollectionViewCell
                cell.configure(
                    message: "No Teams Available",
                    systemImageName: "person.3.fill"
                )
                return cell
            }

            let cell =
                collectionView.dequeueReusableCell(
                    withReuseIdentifier: "TeamCircleCell",
                    for: indexPath
                ) as! TeamCircleCollectionViewCell
            let team = presenter.getTeam(at: indexPath.row)

            cell.configure(
                name: team.displayTeamName,
                imageUrl: team.displayTeamLogo
            )

            cell.NameLabelView?.numberOfLines = 2
            cell.NameLabelView?.textAlignment = .center
            cell.NameLabelView?.lineBreakMode = .byWordWrapping

            return cell
        }
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        let header =
            collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "HeaderView",
                for: indexPath
            ) as! SectionHeaderView

        guard let sectionType = Section(rawValue: indexPath.section) else {
            return header
        }
        switch sectionType {
        case .upcomingEvents: header.titleLabel?.text = "UPCOMING EVENTS"
        case .latestResults: header.titleLabel?.text = "LATEST RESULTS"
        case .teams: header.titleLabel?.text = "TEAMS"
        }
        return header
    }

    // MARK: - Compositional Layout

    private func createCompositionalLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout {
            [weak self] (sectionIndex, _) -> NSCollectionLayoutSection? in
            guard let self = self,
                let sectionType = Section(rawValue: sectionIndex)
            else {
                return nil
            }
            switch sectionType {
            case .upcomingEvents:
                if self.presenter.upcomingEvents.isEmpty {
                    return self.createEmptyUpcomingEventsSection()
                } else {
                    return self.createUpcomingEventsSection()
                }
            case .latestResults: return self.createLatestResultsSection()
            case .teams: return self.createTeamsSection()
            }
        }
    }

    private func createEmptyUpcomingEventsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(100)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 16,
            bottom: 20,
            trailing: 16
        )
        section.boundarySupplementaryItems = [createHeader()]
        return section
    }

    private func createUpcomingEventsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.35),
            heightDimension: .absolute(120)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 16,
            bottom: 20,
            trailing: 16
        )
        section.boundarySupplementaryItems = [createHeader()]
        return section
    }

    private func createLatestResultsSection() -> NSCollectionLayoutSection {
        let isEmpty = presenter.latestResults.isEmpty

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: isEmpty
                ? .fractionalHeight(1.0) : .fractionalHeight(0.33)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupHeight: CGFloat = isEmpty ? 140 : (140 * 3) + (16 * 2)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.9),
            heightDimension: .absolute(groupHeight)
        )

        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitem: item,
            count: isEmpty ? 1 : 3
        )
        group.interItemSpacing = .fixed(16)

        let section = NSCollectionLayoutSection(group: group)

        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary

        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 16,
            bottom: 20,
            trailing: 16
        )

        section.boundarySupplementaryItems = [createHeader()]
        return section
    }

    private func createTeamsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(90),
            heightDimension: .absolute(120)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 12
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 16,
            bottom: 20,
            trailing: 16
        )
        section.boundarySupplementaryItems = [createHeader()]
        return section
    }

    private func createHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(40)
        )
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
    }
}
