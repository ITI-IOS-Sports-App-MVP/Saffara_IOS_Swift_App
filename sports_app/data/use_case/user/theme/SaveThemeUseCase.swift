//
//  SaveThemeUseCase.swift
//  sports_app
//
//  Created by Abdullh Gaber on 23/05/2026.
//

import Foundation

class SaveThemeUseCase: SaveThemeUseCaseProtocol {
    
    private let userRepo: UserRepoProtocol
    
    init(userRepo: UserRepoProtocol) {
        self.userRepo = userRepo
    }
    
    func execute(isDarkMode: Bool) {
        userRepo.saveTheme(isDarkMode: isDarkMode)
    }
}
