//
//  OnboardingPresenter.swift
//  sports_app
//
//  Created by Abdullh Gaber on 23/05/2026.
//

import Foundation

protocol OnboardingViewProtocol: AnyObject {
    func navigateToHome()
}

class OnboardingPresenter {
    
    private weak var view: OnboardingViewProtocol?
    private let saveFirstEntryUseCase: SaveFirstEntryUseCaseProtocol
    
    init(view: OnboardingViewProtocol, saveFirstEntryUseCase: SaveFirstEntryUseCaseProtocol) {
        self.view = view
        self.saveFirstEntryUseCase = saveFirstEntryUseCase
    }
    
    func onGetStartedTapped() {
        saveFirstEntryUseCase.execute(isFirstEntry: false)
        view?.navigateToHome()
    }
    
    func onSkipTapped() {
        saveFirstEntryUseCase.execute(isFirstEntry: false)
        view?.navigateToHome()
    }
}
