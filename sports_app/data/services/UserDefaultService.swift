//
//  UserDefaultService.swift
//  sports_app
//
//  Created by Abdullh Gaber on 23/05/2026.
//

import UIKit

class UserDefaultService: UserDefaultServiceProtocol {
    
    private let userDefaults: UserDefaults
    private let firstEntryKey = "isFirstEntry"
    private let themeKey = "isDarkMode"
    private let languageKey = "appLanguage"
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func saveFirstEntry(_ isFirstEntry: Bool) {
        userDefaults.set(isFirstEntry, forKey: firstEntryKey)
    }
    
    func readFirstEntry() -> Bool {
        if userDefaults.object(forKey: firstEntryKey) == nil {
            return true
        }
        return userDefaults.bool(forKey: firstEntryKey)
    }
    
    func saveTheme(isDarkMode: Bool) {
        userDefaults.set(isDarkMode, forKey: themeKey)
    }
    
    func readTheme() -> Bool {
        if userDefaults.object(forKey: themeKey) == nil {
            return UIScreen.main.traitCollection.userInterfaceStyle == .dark
        }
        return userDefaults.bool(forKey: themeKey)
    }
    
    func saveLanguage(_ languageCode: String) {
        userDefaults.set(languageCode, forKey: languageKey)
    }
    
    func readLanguage() -> String {
        if let saved = userDefaults.string(forKey: languageKey) {
            return saved
        }
        let systemLang = String(Locale.preferredLanguages.first?.prefix(2) ?? "en")
        return systemLang
    }
}
