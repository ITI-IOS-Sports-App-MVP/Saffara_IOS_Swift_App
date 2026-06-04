//
//  AppDIContainer.swift
//  sports_app
//
//  Created by Antigravity on 04/06/2026.
//

import Foundation
import Swinject

class AppDIContainer {
    static let shared = AppDIContainer()
    
    let container = Container()
    
    private init() {
        registerDependencies()
    }
    
    private func registerDependencies() {
        // MARK: - Services
        container.register(UserDefaultServiceProtocol.self) { _ in
            UserDefaultService()
        }.inObjectScope(.container)
        
        container.register(CoreDataManagerProtocol.self) { _ in
            CoreDataManager.shared
        }.inObjectScope(.container)
        
        container.register(LeaguesNetworkServiceProtocol.self) { _ in
            LeaguesNetworkService()
        }.inObjectScope(.container)
        
        container.register(TeamsNetworkServiceProtocol.self) { _ in
            TeamsNetworkService()
        }.inObjectScope(.container)
        
        // MARK: - Repositories
        container.register(UserRepoProtocol.self) { r in
            UserRepo(userDefaultService: r.resolve(UserDefaultServiceProtocol.self)!)
        }.inObjectScope(.container)
        
        container.register(LeaguesRepoProtocol.self) { _ in
            LeaguesRepository()
        }
        
        container.register(FavoriteLeaguesRepoProtocol.self) { _ in
            FavoriteLeaguesRepository()
        }
        
        container.register(LeagueDetailsRepoProtocol.self) { (r, sport: String) in
            LeagueDetailsRepository(
                sport: sport,
                leaguesNetworkService: r.resolve(LeaguesNetworkServiceProtocol.self)!,
                teamsNetworkService: r.resolve(TeamsNetworkServiceProtocol.self)!
            )
        }
        
        container.register(TeamDetailsRepoProtocol.self) { _ in
            TeamDetailsRepository()
        }
        
        // MARK: - Use Cases
        container.register(ReadFirstEntryUseCaseProtocol.self) { r in
            ReadFirstEntryUseCase(userRepo: r.resolve(UserRepoProtocol.self)!)
        }
        
        container.register(SaveFirstEntryUseCaseProtocol.self) { r in
            SaveFirstEntryUseCase(userRepo: r.resolve(UserRepoProtocol.self)!)
        }
        
        container.register(ReadThemeUseCaseProtocol.self) { r in
            ReadThemeUseCase(userRepo: r.resolve(UserRepoProtocol.self)!)
        }
        
        container.register(SaveThemeUseCaseProtocol.self) { r in
            SaveThemeUseCase(userRepo: r.resolve(UserRepoProtocol.self)!)
        }
        
        container.register(ReadLanguageUseCaseProtocol.self) { r in
            ReadLanguageUseCase(userRepo: r.resolve(UserRepoProtocol.self)!)
        }
        
        container.register(SaveLanguageUseCaseProtocol.self) { r in
            SaveLanguageUseCase(userRepo: r.resolve(UserRepoProtocol.self)!)
        }
        
        container.register(GetLeaguesUseCaseProtocol.self) { r in
            GetLeaguesUseCase(repository: r.resolve(LeaguesRepoProtocol.self)!)
        }
        
        container.register(AddFavoriteUseCaseProtocol.self) { r in
            AddFavoriteUseCase(repository: r.resolve(FavoriteLeaguesRepoProtocol.self)!)
        }
        
        container.register(GetFavoritesUseCaseProtocol.self) { r in
            GetFavoritesUseCase(repository: r.resolve(FavoriteLeaguesRepoProtocol.self)!)
        }
        
        container.register(RemoveFavoriteUseCaseProtocol.self) { r in
            RemoveFavoriteUseCase(repository: r.resolve(FavoriteLeaguesRepoProtocol.self)!)
        }
        
        container.register(GetUpcomingEventsUseCaseProtocol.self) { (r, repository: LeagueDetailsRepoProtocol) in
            GetUpcomingEventsUseCase(repository: repository)
        }
        
        container.register(GetLatestResultsUseCaseProtocol.self) { (r, repository: LeagueDetailsRepoProtocol) in
            GetLatestResultsUseCase(repository: repository)
        }
        
        container.register(GetTeamsUseCaseProtocol.self) { (r, repository: LeagueDetailsRepoProtocol) in
            GetTeamsUseCase(repository: repository)
        }
        
        container.register(GetTeamDetailsUseCaseProtocol.self) { r in
            GetTeamDetailsUseCase(repository: r.resolve(TeamDetailsRepoProtocol.self)!)
        }
    }
}
