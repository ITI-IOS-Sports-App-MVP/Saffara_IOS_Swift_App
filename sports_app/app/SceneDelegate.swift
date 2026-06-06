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
        
        let splashVC = SplashVideoViewController()
        
        splashVC.onVideoFinished = { [weak self] in
            self?.navigateAfterSplash(isFirstEntry: isFirstEntry, container: container)
        }
        
        window?.rootViewController = splashVC
        window?.makeKeyAndVisible()
    }

    private func navigateAfterSplash(isFirstEntry: Bool, container: Container) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootVC: UIViewController
        
        if isFirstEntry {
            // First time user → show onboarding
            let onboardingVC = storyboard.instantiateViewController(withIdentifier: "OnboardingViewController") as! OnboardingViewController
            
            let saveFirstEntryUseCase = container.resolve(SaveFirstEntryUseCaseProtocol.self)!
            let presenter = OnboardingPresenter(view: onboardingVC, saveFirstEntryUseCase: saveFirstEntryUseCase)
            onboardingVC.presenter = presenter
            rootVC = onboardingVC
        } else {
            // Returning user → go straight to home
            let homeVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
            rootVC = homeVC
        }
        
        guard let window = window else { return }
        window.rootViewController = rootVC
        UIView.transition(with: window, duration: 0.4, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
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


