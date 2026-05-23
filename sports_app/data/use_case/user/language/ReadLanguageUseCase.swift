//
//  ReadLanguageUseCase.swift
//  sports_app
//
//  Created by Abdullh Gaber on 23/05/2026.
//

import Foundation

class ReadLanguageUseCase: ReadLanguageUseCaseProtocol {
    
    private let userRepo: UserRepoProtocol
    
    init(userRepo: UserRepoProtocol) {
        self.userRepo = userRepo
    }
    
    func execute() -> String {
        return userRepo.readLanguage()
    }
}
