//
//  HomeViewController.swift
//  Saffara
//
//  Created by Thaowpsta Saiid on 20/05/2026.
//

import UIKit

protocol HomeViewProtocol: AnyObject {
    func reloadCollectionView()
    func updateThemeIcon(isDarkMode: Bool)
    func updateLanguageLabel(languageCode: String)
    func applyTheme(isDarkMode: Bool)
    func applyLanguage(languageCode: String, isInitial: Bool)
    func navigateToLeagues(with sportName: String)
}

class HomeViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var themeButton: UIButton!
    
    var presenter: HomePresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 13),
            ]
        
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
                string: "search_sports_placeholder".localized,
                attributes: placeholderAttributes
            )
        
        let userDefaultService = UserDefaultService()
        let userRepo = UserRepo(userDefaultService: userDefaultService)
        let readThemeUseCase = ReadThemeUseCase(userRepo: userRepo)
        let saveThemeUseCase = SaveThemeUseCase(userRepo: userRepo)
        let readLanguageUseCase = ReadLanguageUseCase(userRepo: userRepo)
        let saveLanguageUseCase = SaveLanguageUseCase(userRepo: userRepo)
        
        presenter = HomePresenter(
            view: self,
            readThemeUseCase: readThemeUseCase,
            saveThemeUseCase: saveThemeUseCase,
            readLanguageUseCase: readLanguageUseCase,
            saveLanguageUseCase: saveLanguageUseCase
        )
        
        setupControls()
        setupCollectionView()
        searchBar.delegate = self
        
        presenter.viewDidLoad()
    }
    
    private func setupControls() {
        let langTap = UITapGestureRecognizer(target: self, action: #selector(languageTapped))
        languageLabel.addGestureRecognizer(langTap)
        
        themeButton.addTarget(self, action: #selector(themeTapped), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [languageLabel, themeButton])
            stackView.axis = .horizontal
            stackView.spacing = 16
            stackView.alignment = .center
        
        let barButtonItem = UIBarButtonItem(customView: stackView)
        self.navigationItem.rightBarButtonItem = barButtonItem
    }
    
    @objc private func languageTapped() {
        presenter.toggleLanguage()
    }
    
    @objc private func themeTapped() {
        presenter.toggleTheme()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

// MARK: - HomeViewProtocol Implementation
extension HomeViewController: HomeViewProtocol {
    func reloadCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func updateThemeIcon(isDarkMode: Bool) {
        let iconName = isDarkMode ? "moon.fill" : "sun.max.fill"
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        themeButton.setImage(UIImage(systemName: iconName, withConfiguration: config), for: .normal)
    }
    
    func updateLanguageLabel(languageCode: String) {
        languageLabel.text = languageCode.uppercased()
    }
    
    func applyTheme(isDarkMode: Bool) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            for window in windowScene.windows {
                UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve) {
                    window.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
                }
            }
        }
    }
    
    func applyLanguage(languageCode: String, isInitial: Bool) {
        UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        let isRTL = (languageCode == "ar")
        let attribute: UISemanticContentAttribute = isRTL ? .forceRightToLeft : .forceLeftToRight
        UIView.appearance().semanticContentAttribute = attribute
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            for window in windowScene.windows {
                window.semanticContentAttribute = attribute
            }
            
            if !isInitial, let window = windowScene.windows.first {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let homeVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as? UITabBarController {
                    window.rootViewController = homeVC
                
                    UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
                }
                return
            }
        }
        
        if let tabBarController = self.tabBarController {
            let tabTitles = [
                "tab_sports".localized,
                "tab_favorites".localized,
                "tab_settings".localized
            ]
            for (index, item) in (tabBarController.tabBar.items ?? []).enumerated() {
                if index < tabTitles.count {
                    item.title = tabTitles[index]
                }
            }
        }
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 13),
        ]
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "search_sports_placeholder".localized,
            attributes: placeholderAttributes
        )
        
        presenter.refreshSportsData()
    }
    
    // MARK: Navigation Logic
    func navigateToLeagues(with sportName: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let leaguesVC = storyboard.instantiateViewController(withIdentifier: "LeaguesViewController") as? LeaguesViewController else {
            print("Error: Could not find LeaguesViewController in Storyboard")
            return
        }
        
        // Clean Architecture Dependency Injection
        let repository = LeaguesRepository()
        let useCase = GetLeaguesUseCase(repository: repository)
        let leaguesPresenter = LeaguesPresenter(view: leaguesVC, getLeaguesUseCase: useCase, sportName: sportName)
        
        leaguesVC.presenter = leaguesPresenter
        
        // Push the view controller
        self.navigationController?.pushViewController(leaguesVC, animated: true)
    }
}

// MARK: - UICollectionView Delegate & DataSource
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return .zero
        }
        let spacing = flowLayout.minimumInteritemSpacing
        let availableWidth = collectionView.bounds.width - spacing
        let cellWidth = availableWidth / 2
        let cellHeight = cellWidth * 1.15
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.getSportsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SportCell", for: indexPath) as! HomeCollectionViewCell
        
        let sport = presenter.getSport(at: indexPath.row)
        cell.configure(with: sport)
        
        return cell
    }
    
    // Detect Tap and trigger navigation via Presenter
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        presenter.didSelectSport(at: indexPath.row)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.searchSports(with: searchText)
    }
}
