//
//  SaveLanguageUseCase.swift
//  sports_app
//
//  Created by Abdullh Gaber on 23/05/2026.
//

import Foundation

class SaveLanguageUseCase: SaveLanguageUseCaseProtocol {
    
    private let userRepo: UserRepoProtocol
    
    init(userRepo: UserRepoProtocol) {
        self.userRepo = userRepo
    }
    
    func execute(languageCode: String) {
        userRepo.saveLanguage(languageCode)
    }
}
