//
//  LeagueDetailsViewController.swift
//  sports_app
//
//  Created by Thaowpsta Saiid on 29/05/2026.
//

import Swinject
import UIKit

class LeagueDetailsViewController: UICollectionViewController,
    LeagueDetailsViewProtocol
{

    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    @IBOutlet weak var notificationButton: UIBarButtonItem!
    var presenter: LeagueDetailsPresenter!

    private var skeletonView: LeagueDetailsSkeletonView?
    private var isLoading = false

    enum Section: Int, CaseIterable {
        case upcomingEvents = 0
        case latestResults = 1
        case teams = 2
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupLoadingIndicator()
        
        updateNotificationIcon(isSet: false)
        
        presenter.viewDidLoad()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(resetNotificationIcon),
            name: Notification.Name("ScheduledAlertFired"),
            object: nil
        )
    }

    @objc private func resetNotificationIcon() {
        DispatchQueue.main.async {
            self.presenter.alertDidFire()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }

    @IBAction func favoriteButtonTapped(_ sender: Any) {
        presenter.favoriteButtonTapped()
    }

    @IBAction func addAlertButtonTapped(_ sender: Any) {
        let alertTitle = "set_alert_title".localized + "\n\n\n\n\n\n\n\n"

        let alertVC = UIAlertController(
            title: alertTitle,
            message: nil,
            preferredStyle: .actionSheet
        )

        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }

        datePicker.frame = CGRect(
            x: 0,
            y: 40,
            width: alertVC.view.bounds.width - 20,
            height: 160
        )
        alertVC.view.addSubview(datePicker)

        let setAction = UIAlertAction(
            title: "set_reminder_button".localized,
            style: .default
        ) { [weak self] _ in
            let selectedDate = datePicker.date
            
            self?.presenter.scheduleAlert(for: selectedDate)
        }

        let cancelAction = UIAlertAction(
            title: "cancel".localized,
            style: .cancel
        )

        alertVC.addAction(setAction)
        alertVC.addAction(cancelAction)

        if let popover = alertVC.popoverPresentationController {
            popover.barButtonItem = sender as? UIBarButtonItem
            popover.sourceView = self.view
            popover.sourceRect = CGRect(
                x: self.view.bounds.midX,
                y: self.view.bounds.midY,
                width: 0,
                height: 0
            )
            popover.permittedArrowDirections = []
        }

        present(alertVC, animated: true)
    }

    func showSuccessMessage(_ message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "success_title".localized,
                message: message,
                preferredStyle: .alert
            )

            self.present(alert, animated: true) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    [weak alert] in
                    alert?.dismiss(animated: true, completion: nil)
                }

                if let alertBackground = alert.view.superview?.subviews.first {
                    alertBackground.isUserInteractionEnabled = true
                    let tapGesture = UITapGestureRecognizer(
                        target: self,
                        action: #selector(self.dismissAlertController)
                    )
                    alertBackground.addGestureRecognizer(tapGesture)
                }
            }
        }
    }

    @objc private func dismissAlertController() {
        self.presentedViewController?.dismiss(animated: true, completion: nil)
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
        let skView = LeagueDetailsSkeletonView()
        self.skeletonView = skView
    }

    func showLoadingIndicator() {
        DispatchQueue.main.async {
            self.isLoading = true
            self.collectionView.reloadData()

            guard let skeleton = self.skeletonView else { return }
            self.collectionView.addSubview(skeleton)
            skeleton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                skeleton.topAnchor.constraint(
                    equalTo: self.view.safeAreaLayoutGuide.topAnchor
                ),
                skeleton.leadingAnchor.constraint(
                    equalTo: self.view.safeAreaLayoutGuide.leadingAnchor
                ),
                skeleton.trailingAnchor.constraint(
                    equalTo: self.view.safeAreaLayoutGuide.trailingAnchor
                ),
                skeleton.bottomAnchor.constraint(
                    equalTo: self.view.safeAreaLayoutGuide.bottomAnchor
                ),
            ])
            self.collectionView.isScrollEnabled = false
            skeleton.startShimmering()
        }
    }

    func hideLoadingIndicator() {
        DispatchQueue.main.async {
            self.isLoading = false
            self.collectionView.reloadData()
            self.skeletonView?.stopShimmering()
            self.skeletonView?.removeFromSuperview()
            self.collectionView.isScrollEnabled = true
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

    func showError(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: title,
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

    }

    func updateNotificationIcon(isSet: Bool) {
        let customColor = UIColor(
            red: 255 / 255,
            green: 107 / 255,
            blue: 53 / 255,
            alpha: 1
        )
        let defaultColor = UIColor.label

        notificationButton.tintColor = isSet ? customColor : defaultColor
    }
    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return isLoading ? 0 : Section.allCases.count
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        guard let sectionType = Section(rawValue: section) else { return 0 }
        switch sectionType {
        case .upcomingEvents:
            return presenter.upcomingEvents.isEmpty
                ? 1 : presenter.upcomingEvents.count
        case .latestResults:
            return presenter.latestResults.isEmpty
                ? 1 : presenter.latestResults.count
        case .teams:
            return presenter.teams.isEmpty
                ? 1 : presenter.teams.count
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

    override func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        guard let sectionType = Section(rawValue: indexPath.section) else { return }
        if cell is EmptyStateCollectionViewCell { return }
        
        switch sectionType {
        case .upcomingEvents:
            cell.animateCellDisplay(duration: 0.4, delay: Double(indexPath.item) * 0.05, type: .scaleIn)
        case .latestResults:
            cell.animateCellDisplay(duration: 0.45, delay: Double(indexPath.item % 3) * 0.06, type: .slideUpWithFade)
        case .teams:
            cell.animateCellDisplay(duration: 0.4, delay: Double(indexPath.item) * 0.04, type: .scaleIn)
        }
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
            case .latestResults:
                if self.presenter.latestResults.isEmpty {
                    return self.createEmptySection()
                } else {
                    return self.createLatestResultsSection()
                }
            case .teams:
                if self.presenter.teams.isEmpty {
                    return self.createEmptySection()
                } else {
                    return self.createTeamsSection()
                }
            }
        }
    }

    private func createEmptySection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(120)
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

    private func createEmptyUpcomingEventsSection() -> NSCollectionLayoutSection
    {
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
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.33)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupHeight: CGFloat = (140 * 3) + (16 * 2)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.9),
            heightDimension: .absolute(groupHeight)
        )

        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitem: item,
            count: 3
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

    override func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let sectionType = Section(rawValue: indexPath.section) else {
            return
        }
        if sectionType == .teams {
            guard NetworkMonitor.shared.isConnected else {
                showError(
                    title: "Error",
                    message:
                        "The internet is disconnected. Cannot view team details."
                )
                return
            }

            let team = presenter.getTeam(at: indexPath.item)
            guard let teamId = team.teamKey else { return }

            let teamDetailsVC = TeamDetailsViewController()
            let container = AppDIContainer.shared.container
            let useCase = container.resolve(GetTeamDetailsUseCaseProtocol.self)!
            let detailsPresenter = TeamDetailsPresenter(
                view: teamDetailsVC,
                getTeamDetailsUseCase: useCase,
                teamId: teamId,
                sport: presenter.sport,
                sportAndLeague:
                    "\(presenter.sport.capitalized) - \(presenter.league.leagueName ?? "")"
            )
            teamDetailsVC.presenter = detailsPresenter
            self.navigationController?.pushViewController(
                teamDetailsVC,
                animated: true
            )
        }
    }
}

class LeagueDetailsSkeletonView: UIView {

    private let scrollView = UIScrollView()
    private let containerStack = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSkeleton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSkeleton()
    }

    private func setupSkeleton() {
        backgroundColor = .systemBackground

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)

        containerStack.axis = .vertical
        containerStack.spacing = 24
        containerStack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(containerStack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            containerStack.topAnchor.constraint(
                equalTo: scrollView.topAnchor,
                constant: 16
            ),
            containerStack.leadingAnchor.constraint(
                equalTo: scrollView.leadingAnchor,
                constant: 16
            ),
            containerStack.trailingAnchor.constraint(
                equalTo: scrollView.trailingAnchor,
                constant: -16
            ),
            containerStack.bottomAnchor.constraint(
                equalTo: scrollView.bottomAnchor,
                constant: -16
            ),
            containerStack.widthAnchor.constraint(
                equalTo: scrollView.widthAnchor,
                constant: -32
            ),
        ])

        // 1. Upcoming Section
        createSection(title: "UPCOMING EVENTS", height: 120) {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.spacing = 16
            rowStack.distribution = .fillEqually

            for _ in 0..<3 {
                let card = UIView()
                card.backgroundColor = .secondarySystemGroupedBackground
                card.layer.cornerRadius = 12
                card.layer.shadowColor = UIColor.black.cgColor
                card.layer.shadowOpacity = 0.02
                card.layer.shadowOffset = CGSize(width: 0, height: 1)
                card.layer.shadowRadius = 2

                let team1 = UIView()
                team1.backgroundColor = .systemGray5
                team1.layer.cornerRadius = 15
                team1.translatesAutoresizingMaskIntoConstraints = false
                card.addSubview(team1)

                let team2 = UIView()
                team2.backgroundColor = .systemGray5
                team2.layer.cornerRadius = 15
                team2.translatesAutoresizingMaskIntoConstraints = false
                card.addSubview(team2)

                let line = UIView()
                line.backgroundColor = .systemGray5
                line.layer.cornerRadius = 3
                line.translatesAutoresizingMaskIntoConstraints = false
                card.addSubview(line)

                NSLayoutConstraint.activate([
                    team1.centerXAnchor.constraint(
                        equalTo: card.centerXAnchor,
                        constant: -20
                    ),
                    team1.centerYAnchor.constraint(
                        equalTo: card.centerYAnchor,
                        constant: -15
                    ),
                    team1.widthAnchor.constraint(equalToConstant: 30),
                    team1.heightAnchor.constraint(equalToConstant: 30),

                    team2.centerXAnchor.constraint(
                        equalTo: card.centerXAnchor,
                        constant: 20
                    ),
                    team2.centerYAnchor.constraint(
                        equalTo: card.centerYAnchor,
                        constant: -15
                    ),
                    team2.widthAnchor.constraint(equalToConstant: 30),
                    team2.heightAnchor.constraint(equalToConstant: 30),

                    line.centerXAnchor.constraint(equalTo: card.centerXAnchor),
                    line.topAnchor.constraint(
                        equalTo: team1.bottomAnchor,
                        constant: 12
                    ),
                    line.widthAnchor.constraint(
                        equalTo: card.widthAnchor,
                        multiplier: 0.6
                    ),
                    line.heightAnchor.constraint(equalToConstant: 8),
                ])
                rowStack.addArrangedSubview(card)
            }
            return rowStack
        }

        // 2. Latest Results Section
        createSection(title: "LATEST RESULTS", height: 150) {
            let colStack = UIStackView()
            colStack.axis = .vertical
            colStack.spacing = 12
            colStack.distribution = .fillEqually

            for _ in 0..<2 {
                let cell = UIView()
                cell.backgroundColor = .secondarySystemGroupedBackground
                cell.layer.cornerRadius = 12

                let imageLeft = UIView()
                imageLeft.backgroundColor = .systemGray5
                imageLeft.layer.cornerRadius = 18
                imageLeft.translatesAutoresizingMaskIntoConstraints = false
                cell.addSubview(imageLeft)

                let imageRight = UIView()
                imageRight.backgroundColor = .systemGray5
                imageRight.layer.cornerRadius = 18
                imageRight.translatesAutoresizingMaskIntoConstraints = false
                cell.addSubview(imageRight)

                let scoreText = UIView()
                scoreText.backgroundColor = .systemGray5
                scoreText.layer.cornerRadius = 4
                scoreText.translatesAutoresizingMaskIntoConstraints = false
                cell.addSubview(scoreText)

                NSLayoutConstraint.activate([
                    imageLeft.leadingAnchor.constraint(
                        equalTo: cell.leadingAnchor,
                        constant: 20
                    ),
                    imageLeft.centerYAnchor.constraint(
                        equalTo: cell.centerYAnchor
                    ),
                    imageLeft.widthAnchor.constraint(equalToConstant: 36),
                    imageLeft.heightAnchor.constraint(equalToConstant: 36),

                    imageRight.trailingAnchor.constraint(
                        equalTo: cell.trailingAnchor,
                        constant: -20
                    ),
                    imageRight.centerYAnchor.constraint(
                        equalTo: cell.centerYAnchor
                    ),
                    imageRight.widthAnchor.constraint(equalToConstant: 36),
                    imageRight.heightAnchor.constraint(equalToConstant: 36),

                    scoreText.centerXAnchor.constraint(
                        equalTo: cell.centerXAnchor
                    ),
                    scoreText.centerYAnchor.constraint(
                        equalTo: cell.centerYAnchor
                    ),
                    scoreText.widthAnchor.constraint(equalToConstant: 60),
                    scoreText.heightAnchor.constraint(equalToConstant: 16),
                ])
                colStack.addArrangedSubview(cell)
            }
            return colStack
        }

        // 3. Teams Section
        createSection(title: "TEAMS", height: 110) {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.spacing = 16
            rowStack.distribution = .fillEqually

            for _ in 0..<4 {
                let container = UIView()

                let circle = UIView()
                circle.backgroundColor = .systemGray5
                circle.layer.cornerRadius = 35
                circle.translatesAutoresizingMaskIntoConstraints = false
                container.addSubview(circle)

                let text = UIView()
                text.backgroundColor = .systemGray5
                text.layer.cornerRadius = 3
                text.translatesAutoresizingMaskIntoConstraints = false
                container.addSubview(text)

                NSLayoutConstraint.activate([
                    circle.centerXAnchor.constraint(
                        equalTo: container.centerXAnchor
                    ),
                    circle.topAnchor.constraint(equalTo: container.topAnchor),
                    circle.widthAnchor.constraint(equalToConstant: 70),
                    circle.heightAnchor.constraint(equalToConstant: 70),

                    text.centerXAnchor.constraint(
                        equalTo: container.centerXAnchor
                    ),
                    text.topAnchor.constraint(
                        equalTo: circle.bottomAnchor,
                        constant: 8
                    ),
                    text.widthAnchor.constraint(equalToConstant: 50),
                    text.heightAnchor.constraint(equalToConstant: 8),
                ])
                rowStack.addArrangedSubview(container)
            }
            return rowStack
        }
    }

    private func createSection(
        title: String,
        height: CGFloat,
        contentViewBuilder: () -> UIView
    ) {
        let sectionStack = UIStackView()
        sectionStack.axis = .vertical
        sectionStack.spacing = 12

        let titleLabel = UIView()
        titleLabel.backgroundColor = .systemGray4
        titleLabel.layer.cornerRadius = 4
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        sectionStack.addArrangedSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalToConstant: 120),
            titleLabel.heightAnchor.constraint(equalToConstant: 14),
        ])

        let contentView = contentViewBuilder()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        sectionStack.addArrangedSubview(contentView)

        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: height)
        ])

        containerStack.addArrangedSubview(sectionStack)
    }

    func startShimmering() {
        shimmerViewsRecursively(in: containerStack, start: true)
    }

    func stopShimmering() {
        shimmerViewsRecursively(in: containerStack, start: false)
    }

    private func shimmerViewsRecursively(in view: UIView, start: Bool) {
        let isPlaceholder =
            view.backgroundColor == .systemGray4
            || view.backgroundColor == .systemGray5
        if isPlaceholder {
            if start {
                view.startShimmer()
            } else {
                view.stopShimmer()
            }
        }
        for subview in view.subviews {
            if !(subview is UIStackView) {
                shimmerViewsRecursively(in: subview, start: start)
            } else {
                for arranged in (subview as! UIStackView).arrangedSubviews {
                    shimmerViewsRecursively(in: arranged, start: start)
                }
            }
        }
    }
}
