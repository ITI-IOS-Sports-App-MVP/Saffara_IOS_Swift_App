//
//  SettingsPresenter.swift
//  sports_app
//
//  Created by Abdullh Gaber on 24/05/2026.
//

import Foundation

// MARK: - Settings View Protocol
protocol SettingsViewProtocol: AnyObject {
    func updateThemeSelection(isDarkMode: Bool)
    func updateLanguageSelection(languageCode: String)
    func applyTheme(isDarkMode: Bool)
    func applyLanguage(languageCode: String)
}

// MARK: - Settings Presenter Protocol
protocol SettingsPresenterProtocol {
    func viewDidLoad()
    func getCurrentThemeIsDark() -> Bool
    func getCurrentLanguageCode() -> String
    func didSelectTheme(isDarkMode: Bool)
    func didSelectLanguage(languageCode: String)
}

// MARK: - Settings Presenter
class SettingsPresenter: SettingsPresenterProtocol {
    
    private weak var view: SettingsViewProtocol?
    
    private let readThemeUseCase: ReadThemeUseCaseProtocol
    private let saveThemeUseCase: SaveThemeUseCaseProtocol
    private let readLanguageUseCase: ReadLanguageUseCaseProtocol
    private let saveLanguageUseCase: SaveLanguageUseCaseProtocol
    
    private var isDarkMode: Bool = false
    private var currentLanguage: String = "en"
    
    init(view: SettingsViewProtocol,
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
        isDarkMode = readThemeUseCase.execute()
        currentLanguage = readLanguageUseCase.execute()
        
        view?.updateThemeSelection(isDarkMode: isDarkMode)
        view?.updateLanguageSelection(languageCode: currentLanguage)
    }
    
    func getCurrentThemeIsDark() -> Bool {
        return isDarkMode
    }
    
    func getCurrentLanguageCode() -> String {
        return currentLanguage
    }
    
    func didSelectTheme(isDarkMode: Bool) {
        self.isDarkMode = isDarkMode
        saveThemeUseCase.execute(isDarkMode: isDarkMode)
        view?.updateThemeSelection(isDarkMode: isDarkMode)
        view?.applyTheme(isDarkMode: isDarkMode)
    }
    
    func didSelectLanguage(languageCode: String) {
        self.currentLanguage = languageCode
        saveLanguageUseCase.execute(languageCode: languageCode)
        view?.updateLanguageSelection(languageCode: languageCode)
        view?.applyLanguage(languageCode: languageCode)
    }
}
