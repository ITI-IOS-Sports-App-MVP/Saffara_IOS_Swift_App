//
//  TeamDetailsViewController.swift
//  sports_app
//
//  Created by Thaowpsta Saiid on 02/06/2026.
//

import UIKit
import Kingfisher

class TeamDetailsViewController: UIViewController, TeamDetailsViewProtocol {
    
    var presenter: TeamDetailsPresenterProtocol!
    
    private let tableView = UITableView()
    private var skeletonView: TeamDetailsSkeletonView?
    
    // Header components
    private let headerContainer = UIView()
    private let cardView = UIView()
    private let logoImageView = UIImageView()
    private let nameLabel = UILabel()
    private let detailsLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSkeleton()
        presenter.viewDidLoad()
    }
    
    private func setupUI() {
        title = "Team Details"
        view.backgroundColor = .systemGroupedBackground
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PlayerTableViewCell.self, forCellReuseIdentifier: PlayerTableViewCell.reuseIdentifier)
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        setupTableHeader()
    }
    
    private func setupTableHeader() {
        headerContainer.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 180)
        headerContainer.backgroundColor = .clear
        
        cardView.backgroundColor = .secondarySystemGroupedBackground
        cardView.layer.cornerRadius = 16
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.03
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 6
        cardView.translatesAutoresizingMaskIntoConstraints = false
        headerContainer.addSubview(cardView)
        
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.backgroundColor = .systemBackground
        logoImageView.layer.cornerRadius = 40
        logoImageView.clipsToBounds = true
        logoImageView.layer.borderWidth = 1
        logoImageView.layer.borderColor = UIColor.separator.cgColor
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(logoImageView)
        
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        nameLabel.textColor = .label
        nameLabel.textAlignment = .center
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(nameLabel)
        
        detailsLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        detailsLabel.textColor = .secondaryLabel
        detailsLabel.textAlignment = .center
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(detailsLabel)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: headerContainer.topAnchor, constant: 16),
            cardView.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: headerContainer.bottomAnchor, constant: -8),
            
            logoImageView.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            logoImageView.widthAnchor.constraint(equalToConstant: 80),
            logoImageView.heightAnchor.constraint(equalToConstant: 80),
            
            nameLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            detailsLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            detailsLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            detailsLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16)
        ])
        
        tableView.tableHeaderView = headerContainer
    }
    
    private func setupSkeleton() {
        let skView = TeamDetailsSkeletonView()
        self.skeletonView = skView
    }
    
    // MARK: - TeamDetailsViewProtocol
    
    func showLoadingIndicator() {
        DispatchQueue.main.async {
            guard let skeleton = self.skeletonView else { return }
            self.view.addSubview(skeleton)
            skeleton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                skeleton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                skeleton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
                skeleton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
                skeleton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
            ])
            self.tableView.isHidden = true
            skeleton.startShimmering()
        }
    }
    
    func hideLoadingIndicator() {
        DispatchQueue.main.async {
            self.skeletonView?.stopShimmering()
            self.skeletonView?.removeFromSuperview()
            self.tableView.isHidden = false
        }
    }
    
    func displayTeamHeader(name: String, logo: String?, sportAndLeague: String) {
        DispatchQueue.main.async {
            self.nameLabel.text = name
            self.detailsLabel.text = sportAndLeague
            
            let placeholder = UIImage(systemName: "sportscourt.fill")
            if let logoStr = logo, let url = URL(string: logoStr) {
                self.logoImageView.kf.setImage(with: url, placeholder: placeholder)
            } else {
                self.logoImageView.image = placeholder
            }
        }
    }
    
    func reloadPlayersList() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func showError(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension TeamDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.getPlayersCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlayerTableViewCell.reuseIdentifier, for: indexPath) as? PlayerTableViewCell else {
            return UITableViewCell()
        }
        if let player = presenter?.getPlayer(at: indexPath.row) {
            cell.configure(with: player)
        }
        return cell
    }
}

// MARK: - Skeleton View

class TeamDetailsSkeletonView: UIView {
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
        containerStack.spacing = 16
        containerStack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(containerStack)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            containerStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            containerStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            containerStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            containerStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            containerStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
        
        // 1. Header Card Skeleton
        let headerCard = UIView()
        headerCard.backgroundColor = .secondarySystemGroupedBackground
        headerCard.layer.cornerRadius = 16
        headerCard.translatesAutoresizingMaskIntoConstraints = false
        containerStack.addArrangedSubview(headerCard)
        
        NSLayoutConstraint.activate([
            headerCard.heightAnchor.constraint(equalToConstant: 180)
        ])
        
        let mockLogo = UIView()
        mockLogo.backgroundColor = .systemGray5
        mockLogo.layer.cornerRadius = 40
        mockLogo.translatesAutoresizingMaskIntoConstraints = false
        headerCard.addSubview(mockLogo)
        
        let mockName = UIView()
        mockName.backgroundColor = .systemGray5
        mockName.layer.cornerRadius = 4
        mockName.translatesAutoresizingMaskIntoConstraints = false
        headerCard.addSubview(mockName)
        
        let mockSub = UIView()
        mockSub.backgroundColor = .systemGray5
        mockSub.layer.cornerRadius = 3
        mockSub.translatesAutoresizingMaskIntoConstraints = false
        headerCard.addSubview(mockSub)
        
        NSLayoutConstraint.activate([
            mockLogo.centerXAnchor.constraint(equalTo: headerCard.centerXAnchor),
            mockLogo.topAnchor.constraint(equalTo: headerCard.topAnchor, constant: 16),
            mockLogo.widthAnchor.constraint(equalToConstant: 80),
            mockLogo.heightAnchor.constraint(equalToConstant: 80),
            
            mockName.centerXAnchor.constraint(equalTo: headerCard.centerXAnchor),
            mockName.topAnchor.constraint(equalTo: mockLogo.bottomAnchor, constant: 12),
            mockName.widthAnchor.constraint(equalTo: headerCard.widthAnchor, multiplier: 0.5),
            mockName.heightAnchor.constraint(equalToConstant: 16),
            
            mockSub.centerXAnchor.constraint(equalTo: headerCard.centerXAnchor),
            mockSub.topAnchor.constraint(equalTo: mockName.bottomAnchor, constant: 8),
            mockSub.widthAnchor.constraint(equalTo: headerCard.widthAnchor, multiplier: 0.3),
            mockSub.heightAnchor.constraint(equalToConstant: 10)
        ])
        
        // 2. Player Cells Skeletons
        for _ in 0..<3 {
            let cellCard = UIView()
            cellCard.backgroundColor = .secondarySystemGroupedBackground
            cellCard.layer.cornerRadius = 14
            cellCard.translatesAutoresizingMaskIntoConstraints = false
            containerStack.addArrangedSubview(cellCard)
            
            NSLayoutConstraint.activate([
                cellCard.heightAnchor.constraint(equalToConstant: 160)
            ])
            
            let mockProfile = UIView()
            mockProfile.backgroundColor = .systemGray5
            mockProfile.layer.cornerRadius = 25
            mockProfile.translatesAutoresizingMaskIntoConstraints = false
            cellCard.addSubview(mockProfile)
            
            let mockPlayerName = UIView()
            mockPlayerName.backgroundColor = .systemGray5
            mockPlayerName.layer.cornerRadius = 4
            mockPlayerName.translatesAutoresizingMaskIntoConstraints = false
            cellCard.addSubview(mockPlayerName)
            
            let mockPlayerDetails = UIView()
            mockPlayerDetails.backgroundColor = .systemGray5
            mockPlayerDetails.layer.cornerRadius = 3
            mockPlayerDetails.translatesAutoresizingMaskIntoConstraints = false
            cellCard.addSubview(mockPlayerDetails)
            
            let mockBadge = UIView()
            mockBadge.backgroundColor = .systemGray5
            mockBadge.layer.cornerRadius = 8
            mockBadge.translatesAutoresizingMaskIntoConstraints = false
            cellCard.addSubview(mockBadge)
            
            let mockSep = UIView()
            mockSep.backgroundColor = .systemGray5
            mockSep.translatesAutoresizingMaskIntoConstraints = false
            cellCard.addSubview(mockSep)
            
            NSLayoutConstraint.activate([
                mockProfile.topAnchor.constraint(equalTo: cellCard.topAnchor, constant: 16),
                mockProfile.leadingAnchor.constraint(equalTo: cellCard.leadingAnchor, constant: 16),
                mockProfile.widthAnchor.constraint(equalToConstant: 50),
                mockProfile.heightAnchor.constraint(equalToConstant: 50),
                
                mockPlayerName.topAnchor.constraint(equalTo: cellCard.topAnchor, constant: 20),
                mockPlayerName.leadingAnchor.constraint(equalTo: mockProfile.trailingAnchor, constant: 12),
                mockPlayerName.widthAnchor.constraint(equalTo: cellCard.widthAnchor, multiplier: 0.4),
                mockPlayerName.heightAnchor.constraint(equalToConstant: 12),
                
                mockPlayerDetails.topAnchor.constraint(equalTo: mockPlayerName.bottomAnchor, constant: 8),
                mockPlayerDetails.leadingAnchor.constraint(equalTo: mockPlayerName.leadingAnchor),
                mockPlayerDetails.widthAnchor.constraint(equalTo: cellCard.widthAnchor, multiplier: 0.25),
                mockPlayerDetails.heightAnchor.constraint(equalToConstant: 8),
                
                mockBadge.topAnchor.constraint(equalTo: cellCard.topAnchor, constant: 16),
                mockBadge.trailingAnchor.constraint(equalTo: cellCard.trailingAnchor, constant: -16),
                mockBadge.widthAnchor.constraint(equalToConstant: 34),
                mockBadge.heightAnchor.constraint(equalToConstant: 24),
                
                mockSep.topAnchor.constraint(equalTo: mockProfile.bottomAnchor, constant: 12),
                mockSep.leadingAnchor.constraint(equalTo: cellCard.leadingAnchor, constant: 16),
                mockSep.trailingAnchor.constraint(equalTo: cellCard.trailingAnchor, constant: -16),
                mockSep.heightAnchor.constraint(equalToConstant: 1)
            ])
            
            // Add 3 rows of stats
            let statsStack = UIStackView()
            statsStack.axis = .vertical
            statsStack.spacing = 8
            statsStack.distribution = .fillEqually
            statsStack.translatesAutoresizingMaskIntoConstraints = false
            cellCard.addSubview(statsStack)
            
            NSLayoutConstraint.activate([
                statsStack.topAnchor.constraint(equalTo: mockSep.bottomAnchor, constant: 12),
                statsStack.leadingAnchor.constraint(equalTo: cellCard.leadingAnchor, constant: 16),
                statsStack.trailingAnchor.constraint(equalTo: cellCard.trailingAnchor, constant: -16),
                statsStack.bottomAnchor.constraint(equalTo: cellCard.bottomAnchor, constant: -16)
            ])
            
            for _ in 0..<3 {
                let statRow = UIStackView()
                statRow.axis = .horizontal
                statRow.distribution = .equalSpacing
                
                let titlePl = UIView()
                titlePl.backgroundColor = .systemGray5
                titlePl.layer.cornerRadius = 3
                titlePl.translatesAutoresizingMaskIntoConstraints = false
                
                let valPl = UIView()
                valPl.backgroundColor = .systemGray5
                valPl.layer.cornerRadius = 3
                valPl.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint.activate([
                    titlePl.widthAnchor.constraint(equalToConstant: 60),
                    titlePl.heightAnchor.constraint(equalToConstant: 8),
                    valPl.widthAnchor.constraint(equalToConstant: 20),
                    valPl.heightAnchor.constraint(equalToConstant: 8)
                ])
                
                statRow.addArrangedSubview(titlePl)
                statRow.addArrangedSubview(valPl)
                statsStack.addArrangedSubview(statRow)
            }
        }
    }
    
    func startShimmering() {
        shimmerViewsRecursively(in: containerStack, start: true)
    }
    
    func stopShimmering() {
        shimmerViewsRecursively(in: containerStack, start: false)
    }
    
    private func shimmerViewsRecursively(in view: UIView, start: Bool) {
        let isPlaceholder = view.backgroundColor == .systemGray4 || view.backgroundColor == .systemGray5
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
