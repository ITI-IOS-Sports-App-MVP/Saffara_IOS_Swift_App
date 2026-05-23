//
//  HomeViewProtocol.swift
//  sports_app
//
//  Created by Thaowpsta Saiid on 23/05/2026.
//


import Foundation
import UIKit

protocol HomeViewProtocol: AnyObject {
    func reloadCollectionView()
    func updateThemeIcon(isDarkMode: Bool)
    func updateLanguageLabel(languageCode: String)
    func applyTheme(isDarkMode: Bool)
    func applyLanguage(languageCode: String, isInitial: Bool)
}

class HomePresenter {
    
    private weak var view: HomeViewProtocol?
    
    private var sports: [SportCard] = []
    private var filteredSports: [SportCard] = []
    
    private let readThemeUseCase: ReadThemeUseCaseProtocol
    private let saveThemeUseCase: SaveThemeUseCaseProtocol
    private let readLanguageUseCase: ReadLanguageUseCaseProtocol
    private let saveLanguageUseCase: SaveLanguageUseCaseProtocol
    
    private var isDarkMode: Bool = false
    private var currentLanguage: String = "en"
    
    init(view: HomeViewProtocol,
         readThemeUseCase: ReadThemeUseCaseProtocol,
         saveThemeUseCase: SaveThemeUseCaseProtocol,
         readLanguageUseCase: ReadLanguageUseCaseProtocol,
         saveLanguageUseCase: SaveLanguageUseCaseProtocol) {
        self.view = view
        self.readThemeUseCase = readThemeUseCase
        self.saveThemeUseCase = saveThemeUseCase
        self.readLanguageUseCase = readLanguageUseCase
        self.saveLanguageUseCase = saveLanguageUseCase
    }
    
    func viewDidLoad() {
        // Load saved preferences
        isDarkMode = readThemeUseCase.execute()
        currentLanguage = readLanguageUseCase.execute()
        
        view?.updateThemeIcon(isDarkMode: isDarkMode)
        view?.updateLanguageLabel(languageCode: currentLanguage)
        view?.applyTheme(isDarkMode: isDarkMode)
        view?.applyLanguage(languageCode: currentLanguage, isInitial: true)
        
        fetchSportsData()
    }
    
    private func fetchSportsData() {
        sports = [
            SportCard(name: "sport_soccer".localized, icon: "⚽️", iconBackgroundColor: UIColor(red: 0.1, green: 0.2, blue: 0.3, alpha: 1.0)),
            SportCard(name: "sport_basketball".localized, icon: "🏀", iconBackgroundColor: UIColor(red: 0.3, green: 0.1, blue: 0.1, alpha: 1.0)),
            SportCard(name: "sport_tennis".localized, icon: "🎾", iconBackgroundColor: UIColor(red: 0.1, green: 0.2, blue: 0.1, alpha: 1.0)),
            SportCard(name: "sport_american_football".localized, icon: "🏈", iconBackgroundColor: UIColor(red: 0.2, green: 0.2, blue: 0.1, alpha: 1.0))
        ]
        filteredSports = sports
        view?.reloadCollectionView()
    }
    
    func refreshSportsData() {
        fetchSportsData()
    }
    
    func getSportsCount() -> Int {
        return filteredSports.count
    }
    
    func getSport(at index: Int) -> SportCard {
        return filteredSports[index]
    }
        
    func searchSports(with query: String) {
        if query.isEmpty {
            filteredSports = sports
        } else {
            filteredSports = sports.filter { $0.name.localizedCaseInsensitiveContains(query) }
        }
        view?.reloadCollectionView()
    }
    
    // MARK: - Theme
    
    func toggleTheme() {
        isDarkMode.toggle()
        saveThemeUseCase.execute(isDarkMode: isDarkMode)
        view?.updateThemeIcon(isDarkMode: isDarkMode)
        view?.applyTheme(isDarkMode: isDarkMode)
    }
    
    // MARK: - Language
    
    func toggleLanguage() {
        currentLanguage = (currentLanguage == "en") ? "ar" : "en"
        saveLanguageUseCase.execute(languageCode: currentLanguage)
        view?.updateLanguageLabel(languageCode: currentLanguage)
        view?.applyLanguage(languageCode: currentLanguage, isInitial: false)
    }
}

