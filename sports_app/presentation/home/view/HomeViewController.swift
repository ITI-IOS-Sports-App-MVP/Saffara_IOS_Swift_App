//
//  HomeViewCellViewController.swift
//  Saffara
//
//  Created by Thaowpsta Saiid on 20/05/2026.
//

import UIKit

class HomeViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var themeButton: UIButton!
    
    var presenter: HomePresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 13),
            ]
        
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
                string: "search_sports_placeholder".localized,
                attributes: placeholderAttributes
            )
        
        // Build the dependency chain
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
        // Add tap gesture for language toggle
        let langTap = UITapGestureRecognizer(target: self, action: #selector(languageTapped))
        languageLabel.addGestureRecognizer(langTap)
        
        // Add tap action for theme toggle
        themeButton.addTarget(self, action: #selector(themeTapped), for: .touchUpInside)
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
        // Persist the language override for the app
        UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        // Apply layout direction immediately
        let isRTL = (languageCode == "ar")
        let attribute: UISemanticContentAttribute = isRTL ? .forceRightToLeft : .forceLeftToRight
        UIView.appearance().semanticContentAttribute = attribute
        
        // Update active windows
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            for window in windowScene.windows {
                window.semanticContentAttribute = attribute
            }
            
            // Re-instantiate root tab bar controller to refresh all views/layout completely if user toggled language
            if !isInitial, let window = windowScene.windows.first {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let homeVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as? UITabBarController {
                    window.rootViewController = homeVC
                    
                    // Add smooth cross-dissolve animation
                    UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
                }
                return
            }
        }
        
        // Update tab bar titles with localized strings
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
        
        // Update search bar placeholder
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 13),
        ]
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "search_sports_placeholder".localized,
            attributes: placeholderAttributes
        )
        
        // Reload sports data so names update
        presenter.refreshSportsData()
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let padding: CGFloat = 16
    
        
        let totalSpacing = padding * 3
        let availableWidth = collectionView.bounds.width - totalSpacing
        
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            presenter.searchSports(with: searchText)
        }
}
