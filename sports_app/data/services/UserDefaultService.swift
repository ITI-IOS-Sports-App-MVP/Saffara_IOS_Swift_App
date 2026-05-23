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
        // If key doesn't exist yet, UserDefaults returns false for bool.
        // We treat "no value stored" as true (first entry).
        if userDefaults.object(forKey: firstEntryKey) == nil {
            return true
        }
        return userDefaults.bool(forKey: firstEntryKey)
    }
    
    // MARK: - Theme
    
    func saveTheme(isDarkMode: Bool) {
        userDefaults.set(isDarkMode, forKey: themeKey)
    }
    
    func readTheme() -> Bool {
        // If no value saved yet, default to system appearance
        if userDefaults.object(forKey: themeKey) == nil {
            return UIScreen.main.traitCollection.userInterfaceStyle == .dark
        }
        return userDefaults.bool(forKey: themeKey)
    }
    
    // MARK: - Language
    
    func saveLanguage(_ languageCode: String) {
        userDefaults.set(languageCode, forKey: languageKey)
    }
    
    func readLanguage() -> String {
        // If no value saved yet, default to system language
        if let saved = userDefaults.string(forKey: languageKey) {
            return saved
        }
        let systemLang = String(Locale.preferredLanguages.first?.prefix(2) ?? "en")
        return systemLang
    }
}
