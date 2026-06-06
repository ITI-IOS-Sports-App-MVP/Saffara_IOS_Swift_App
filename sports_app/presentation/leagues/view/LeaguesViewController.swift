//
//  LeaguesViewController.swift
//  sports_app
//
//  Created by Thaowpsta Saiid on 23/05/2026.
//

import UIKit
import Swinject

class LeaguesViewController: UITableViewController, LeaguesViewProtocol {

    var presenter: LeaguesPresenterProtocol!

    private var skeletonView: LeaguesSkeletonView?

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
        let skView = LeaguesSkeletonView()
        self.skeletonView = skView
    }

    func showLoadingIndicator() {
        DispatchQueue.main.async {
            guard let skeleton = self.skeletonView else { return }
            self.tableView.addSubview(skeleton)
            skeleton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                skeleton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                skeleton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
                skeleton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
                skeleton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
            ])
            self.tableView.isScrollEnabled = false
            skeleton.startShimmering()
        }
    }

    func hideLoadingIndicator() {
        DispatchQueue.main.async {
            self.skeletonView?.stopShimmering()
            self.skeletonView?.removeFromSuperview()
            self.tableView.isScrollEnabled = true
        }
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

class LeaguesSkeletonView: UIView {
    
    private let stackView = UIStackView()
    
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
        
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
        
        // Add 8 skeleton rows to simulate loading cells
        for _ in 0..<8 {
            let row = createSkeletonRow()
            stackView.addArrangedSubview(row)
            
            // Set explicit height to match exactly the 64pt of containerView inside the cell
            NSLayoutConstraint.activate([
                row.heightAnchor.constraint(equalToConstant: 64)
            ])
        }
    }
    
    private func createSkeletonRow() -> UIView {
        let rowContainer = UIView()
        rowContainer.backgroundColor = .secondarySystemGroupedBackground
        rowContainer.layer.cornerRadius = 14  // matches cell card cornerRadius
        rowContainer.layer.shadowColor = UIColor.black.cgColor
        rowContainer.layer.shadowOpacity = 0.03
        rowContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
        rowContainer.layer.shadowRadius = 4
        
        let mockImage = UIView()
        mockImage.backgroundColor = .systemGray5
        mockImage.layer.cornerRadius = 22  // matches cell image cornerRadius (44 / 2)
        mockImage.translatesAutoresizingMaskIntoConstraints = false
        rowContainer.addSubview(mockImage)
        
        let textStack = UIStackView()
        textStack.axis = .vertical
        textStack.spacing = 6
        textStack.distribution = .fillEqually
        textStack.translatesAutoresizingMaskIntoConstraints = false
        rowContainer.addSubview(textStack)
        
        let mockTitle = UIView()
        mockTitle.backgroundColor = .systemGray5
        mockTitle.layer.cornerRadius = 4
        textStack.addArrangedSubview(mockTitle)
        
        let mockSubtitle = UIView()
        mockSubtitle.backgroundColor = .systemGray5
        mockSubtitle.layer.cornerRadius = 3
        textStack.addArrangedSubview(mockSubtitle)
        
        NSLayoutConstraint.activate([
            mockImage.leadingAnchor.constraint(equalTo: rowContainer.leadingAnchor, constant: 14),
            mockImage.centerYAnchor.constraint(equalTo: rowContainer.centerYAnchor),
            mockImage.widthAnchor.constraint(equalToConstant: 44),
            mockImage.heightAnchor.constraint(equalToConstant: 44),
            
            textStack.leadingAnchor.constraint(equalTo: mockImage.trailingAnchor, constant: 12),
            textStack.trailingAnchor.constraint(equalTo: rowContainer.trailingAnchor, constant: -40),
            textStack.centerYAnchor.constraint(equalTo: rowContainer.centerYAnchor),
            textStack.heightAnchor.constraint(equalToConstant: 34),
            
            mockTitle.widthAnchor.constraint(equalTo: textStack.widthAnchor, multiplier: 0.6),
            mockSubtitle.widthAnchor.constraint(equalTo: textStack.widthAnchor, multiplier: 0.35)
        ])
        
        return rowContainer
    }
    
    func startShimmering() {
        stackView.arrangedSubviews.forEach { row in
            row.subviews.forEach { view in
                if view is UIStackView {
                    view.subviews.forEach { $0.startShimmer() }
                } else {
                    view.startShimmer()
                }
            }
        }
    }
    
    func stopShimmering() {
        stackView.arrangedSubviews.forEach { row in
            row.subviews.forEach { view in
                if view is UIStackView {
                    view.subviews.forEach { $0.stopShimmer() }
                } else {
                    view.stopShimmer()
                }
            }
        }
    }
}
