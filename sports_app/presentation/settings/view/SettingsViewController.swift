//
//  SettingsViewController.swift
//  sports_app
//
//  Created by Abdullh Gaber on 24/05/2026.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - Properties
    var presenter: SettingsPresenterProtocol!
    
    // MARK: - UI Elements
    private let titleLabel = UILabel()
    
    // Appearance Section
    private let appearanceSectionLabel = UILabel()
    private let themeCard = UIView()
    private let themeIconImageView = UIImageView()
    private let themeLabel = UILabel()
    private let themeDropdownButton = UIButton(type: .system)
    
    // Localization Section
    private let localizationSectionLabel = UILabel()
    private let languageCard = UIView()
    private let languageIconImageView = UIImageView()
    private let languageLabel = UILabel()
    private let languageDropdownButton = UIButton(type: .system)
    
    // Accent color matching the app design
    private let accentColor = UIColor(red: 1.0, green: 0.42, blue: 0.21, alpha: 1.0)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDependencies()
        setupUI()
        presenter.viewDidLoad()
    }
    
    // MARK: - Dependency Injection
    private func setupDependencies() {
        if presenter == nil {
            let userDefaultService = UserDefaultService()
            let userRepo = UserRepo(userDefaultService: userDefaultService)
            let readThemeUseCase = ReadThemeUseCase(userRepo: userRepo)
            let saveThemeUseCase = SaveThemeUseCase(userRepo: userRepo)
            let readLanguageUseCase = ReadLanguageUseCase(userRepo: userRepo)
            let saveLanguageUseCase = SaveLanguageUseCase(userRepo: userRepo)
            
            presenter = SettingsPresenter(
                view: self,
                readThemeUseCase: readThemeUseCase,
                saveThemeUseCase: saveThemeUseCase,
                readLanguageUseCase: readLanguageUseCase,
                saveLanguageUseCase: saveLanguageUseCase
            )
        }
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        setupTitleLabel()
        setupAppearanceSection()
        setupLocalizationSection()
    }
    
    private func setupTitleLabel() {
        titleLabel.text = "tab_settings".localized
        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        // Separator line below title
        let separator = UIView()
        separator.backgroundColor = .separator
        separator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(separator)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            separator.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            separator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    private func setupAppearanceSection() {
        // Section Label
        appearanceSectionLabel.text = "settings_appearance".localized
        appearanceSectionLabel.font = UIFont.boldSystemFont(ofSize: 13)
        appearanceSectionLabel.textColor = accentColor
        appearanceSectionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(appearanceSectionLabel)
        
        // Theme Card
        setupCard(themeCard)
        view.addSubview(themeCard)
        
        // Theme Icon
        let themeIconConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        themeIconImageView.image = UIImage(systemName: "paintbrush.fill", withConfiguration: themeIconConfig)
        themeIconImageView.tintColor = accentColor
        themeIconImageView.contentMode = .center
        themeIconImageView.translatesAutoresizingMaskIntoConstraints = false
        themeCard.addSubview(themeIconImageView)
        
        // Theme Label
        themeLabel.text = "settings_app_theme".localized
        themeLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        themeLabel.translatesAutoresizingMaskIntoConstraints = false
        themeCard.addSubview(themeLabel)
        
        // Theme Dropdown Button
        setupDropdownButton(themeDropdownButton, title: "settings_dark_mode".localized)
        themeCard.addSubview(themeDropdownButton)
        
        NSLayoutConstraint.activate([
            appearanceSectionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            appearanceSectionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            themeCard.topAnchor.constraint(equalTo: appearanceSectionLabel.bottomAnchor, constant: 10),
            themeCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            themeCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            themeCard.heightAnchor.constraint(equalToConstant: 52),
            
            themeIconImageView.leadingAnchor.constraint(equalTo: themeCard.leadingAnchor, constant: 16),
            themeIconImageView.centerYAnchor.constraint(equalTo: themeCard.centerYAnchor),
            themeIconImageView.widthAnchor.constraint(equalToConstant: 28),
            themeIconImageView.heightAnchor.constraint(equalToConstant: 28),
            
            themeLabel.leadingAnchor.constraint(equalTo: themeIconImageView.trailingAnchor, constant: 10),
            themeLabel.centerYAnchor.constraint(equalTo: themeCard.centerYAnchor),
            
            themeDropdownButton.trailingAnchor.constraint(equalTo: themeCard.trailingAnchor, constant: -12),
            themeDropdownButton.centerYAnchor.constraint(equalTo: themeCard.centerYAnchor),
            themeDropdownButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 120),
            themeDropdownButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }
    
    private func setupLocalizationSection() {
        // Section Label
        localizationSectionLabel.text = "settings_localization".localized
        localizationSectionLabel.font = UIFont.boldSystemFont(ofSize: 13)
        localizationSectionLabel.textColor = accentColor
        localizationSectionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(localizationSectionLabel)
        
        // Language Card
        setupCard(languageCard)
        view.addSubview(languageCard)
        
        // Language Icon
        let langIconConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        languageIconImageView.image = UIImage(systemName: "character.book.closed.fill", withConfiguration: langIconConfig)
        languageIconImageView.tintColor = accentColor
        languageIconImageView.contentMode = .center
        languageIconImageView.translatesAutoresizingMaskIntoConstraints = false
        languageCard.addSubview(languageIconImageView)
        
        // Language Label
        languageLabel.text = "settings_language".localized
        languageLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        languageLabel.translatesAutoresizingMaskIntoConstraints = false
        languageCard.addSubview(languageLabel)
        
        // Language Dropdown Button
        setupDropdownButton(languageDropdownButton, title: "settings_english".localized)
        languageCard.addSubview(languageDropdownButton)
        
        NSLayoutConstraint.activate([
            localizationSectionLabel.topAnchor.constraint(equalTo: themeCard.bottomAnchor, constant: 24),
            localizationSectionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            languageCard.topAnchor.constraint(equalTo: localizationSectionLabel.bottomAnchor, constant: 10),
            languageCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            languageCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            languageCard.heightAnchor.constraint(equalToConstant: 52),
            
            languageIconImageView.leadingAnchor.constraint(equalTo: languageCard.leadingAnchor, constant: 16),
            languageIconImageView.centerYAnchor.constraint(equalTo: languageCard.centerYAnchor),
            languageIconImageView.widthAnchor.constraint(equalToConstant: 28),
            languageIconImageView.heightAnchor.constraint(equalToConstant: 28),
            
            languageLabel.leadingAnchor.constraint(equalTo: languageIconImageView.trailingAnchor, constant: 10),
            languageLabel.centerYAnchor.constraint(equalTo: languageCard.centerYAnchor),
            
            languageDropdownButton.trailingAnchor.constraint(equalTo: languageCard.trailingAnchor, constant: -12),
            languageDropdownButton.centerYAnchor.constraint(equalTo: languageCard.centerYAnchor),
            languageDropdownButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 120),
            languageDropdownButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }
    
    // MARK: - Helpers
    private func setupCard(_ card: UIView) {
        card.backgroundColor = .secondarySystemBackground
        card.layer.cornerRadius = 12
        card.layer.borderWidth = 0.5
        card.layer.borderColor = UIColor.separator.cgColor
        card.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupDropdownButton(_ button: UIButton, title: String) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.backgroundColor = .tertiarySystemBackground
        button.layer.cornerRadius = 8
        button.contentHorizontalAlignment = .center
        
        // Add chevron
        let chevronConfig = UIImage.SymbolConfiguration(pointSize: 10, weight: .medium)
        let chevronImage = UIImage(systemName: "chevron.down", withConfiguration: chevronConfig)
        button.setImage(chevronImage, for: .normal)
        button.tintColor = .label
        button.semanticContentAttribute = .forceRightToLeft
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: -6)
        button.contentEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 18)
        
        button.showsMenuAsPrimaryAction = true
    }
    
    // MARK: - Menu Builders
    private func buildThemeMenu(isDarkMode: Bool) -> UIMenu {
        let darkAction = UIAction(
            title: "settings_dark_mode".localized,
            state: isDarkMode ? .on : .off
        ) { [weak self] _ in
            self?.presenter.didSelectTheme(isDarkMode: true)
        }
        
        let lightAction = UIAction(
            title: "settings_light_mode".localized,
            state: !isDarkMode ? .on : .off
        ) { [weak self] _ in
            self?.presenter.didSelectTheme(isDarkMode: false)
        }
        
        return UIMenu(children: [darkAction, lightAction])
    }
    
    private func buildLanguageMenu(languageCode: String) -> UIMenu {
        let englishAction = UIAction(
            title: "settings_english".localized,
            state: languageCode == "en" ? .on : .off
        ) { [weak self] _ in
            self?.presenter.didSelectLanguage(languageCode: "en")
        }
        
        let arabicAction = UIAction(
            title: "settings_arabic".localized,
            state: languageCode == "ar" ? .on : .off
        ) { [weak self] _ in
            self?.presenter.didSelectLanguage(languageCode: "ar")
        }
        
        return UIMenu(children: [englishAction, arabicAction])
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        // Update card border color when appearance changes
        themeCard.layer.borderColor = UIColor.separator.cgColor
        languageCard.layer.borderColor = UIColor.separator.cgColor
    }
}

// MARK: - SettingsViewProtocol
extension SettingsViewController: SettingsViewProtocol {
    
    func updateThemeSelection(isDarkMode: Bool) {
        let title = isDarkMode ? "settings_dark_mode".localized : "settings_light_mode".localized
        themeDropdownButton.setTitle(title, for: .normal)
        themeDropdownButton.menu = buildThemeMenu(isDarkMode: isDarkMode)
    }
    
    func updateLanguageSelection(languageCode: String) {
        let title = languageCode == "en" ? "settings_english".localized : "settings_arabic".localized
        languageDropdownButton.setTitle(title, for: .normal)
        languageDropdownButton.menu = buildLanguageMenu(languageCode: languageCode)
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
    
    func applyLanguage(languageCode: String) {
        UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        let isRTL = (languageCode == "ar")
        let attribute: UISemanticContentAttribute = isRTL ? .forceRightToLeft : .forceLeftToRight
        UIView.appearance().semanticContentAttribute = attribute
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            for window in windowScene.windows {
                window.semanticContentAttribute = attribute
            }
            
            // Recreate the tab bar to apply language change
            if let window = windowScene.windows.first {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let tabBarVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as? UITabBarController {
                    // Force load so tabBar.items are available
                    tabBarVC.loadViewIfNeeded()
                    
                    // Update tab bar item titles with localized strings
                    let tabTitles = [
                        "tab_sports".localized,
                        "tab_favorites".localized,
                        "tab_settings".localized
                    ]
                    if let viewControllers = tabBarVC.viewControllers {
                        for (index, vc) in viewControllers.enumerated() {
                            if index < tabTitles.count {
                                vc.tabBarItem.title = tabTitles[index]
                            }
                        }
                    }
                    
                    // Switch to the Settings tab (index 2)
                    tabBarVC.selectedIndex = 2
                    window.rootViewController = tabBarVC
                    UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
                }
            }
        }
    }
}
