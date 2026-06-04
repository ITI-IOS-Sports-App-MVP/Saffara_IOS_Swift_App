//
//  SceneDelegate.swift
//  sports_app
//
//  Created by Abdullh Gaber on 19/05/2026.
//

import UIKit
import Swinject

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // Resolve the dependencies using AppDIContainer
        let container = AppDIContainer.shared.container
        
        let readFirstEntryUseCase = container.resolve(ReadFirstEntryUseCaseProtocol.self)!
        let readThemeUseCase = container.resolve(ReadThemeUseCaseProtocol.self)!
        let readLanguageUseCase = container.resolve(ReadLanguageUseCaseProtocol.self)!
        
        let isFirstEntry = readFirstEntryUseCase.execute()
        let isDarkMode = readThemeUseCase.execute()
        let currentLanguage = readLanguageUseCase.execute()
        
        // Apply layout direction immediately
        let isRTL = (currentLanguage == "ar")
        let attribute: UISemanticContentAttribute = isRTL ? .forceRightToLeft : .forceLeftToRight
        UIView.appearance().semanticContentAttribute = attribute
        
        window = UIWindow(windowScene: windowScene)
        window?.semanticContentAttribute = attribute
        
        // Apply saved theme to the window immediately
        window?.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if isFirstEntry {
            // First time user → show onboarding
            let onboardingVC = storyboard.instantiateViewController(withIdentifier: "OnboardingViewController") as! OnboardingViewController
            
            let saveFirstEntryUseCase = container.resolve(SaveFirstEntryUseCaseProtocol.self)!
            let presenter = OnboardingPresenter(view: onboardingVC, saveFirstEntryUseCase: saveFirstEntryUseCase)
            onboardingVC.presenter = presenter
            
            window?.rootViewController = onboardingVC
        } else {
            // Returning user → go straight to home
            let homeVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
            window?.rootViewController = homeVC
        }
        
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

// MARK: - Dynamic Localization Helper

class LocalizationManager {
    static let shared = LocalizationManager()
    
    private init() {}
    
    func localizedBundle() -> Bundle {
        let languageKey = "appLanguage"
        let currentLanguage: String
        if let saved = UserDefaults.standard.string(forKey: languageKey) {
            currentLanguage = saved
        } else {
            currentLanguage = String(Locale.preferredLanguages.first?.prefix(2) ?? "en")
        }
        
        if let path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj"),
           let bundle = Bundle(path: path) {
            return bundle
        }
        return Bundle.main
    }
    
    func localizedString(forKey key: String) -> String {
        return NSLocalizedString(key, bundle: localizedBundle(), comment: "")
    }
}

extension String {
    var localized: String {
        return LocalizationManager.shared.localizedString(forKey: self)
    }
}


