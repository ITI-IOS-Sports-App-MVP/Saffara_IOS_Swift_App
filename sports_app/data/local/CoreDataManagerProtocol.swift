//
//  CoreDataManagerProtocol.swift
//  sports_app
//
//  Created by Thaowpsta Saiid on 25/05/2026.
//

import CoreData
import UIKit

protocol CoreDataManagerProtocol {
    func fetchFavorites() throws -> [League]
    func saveFavorite(league: League) throws
    func deleteFavorite(leagueKey: Int) throws
}

class CoreDataManager: CoreDataManagerProtocol {
    static let shared = CoreDataManager()

    private let context = (UIApplication.shared.delegate as! AppDelegate)
        .persistentContainer.viewContext

    private init() {}

    func fetchFavorites() throws -> [League] {
        let request: NSFetchRequest<LeagueEntity> = LeagueEntity.fetchRequest()
        let entities = try context.fetch(request)

        return entities.map { entity in
            League(
                leagueKey: Int(entity.leagueKey),
                leagueName: entity.leagueName,
                leagueLogo: entity.leagueLogo,
                leagueCountry: entity.leagueCountry
            )
        }
    }

    func saveFavorite(league: League) throws {
        let entity = LeagueEntity(context: context)
        entity.leagueKey = Int64(league.leagueKey ?? 0)
        entity.leagueName = league.leagueName
        entity.leagueLogo = league.leagueLogo
        entity.leagueCountry = league.leagueCountry

        try context.save()
    }

    func deleteFavorite(leagueKey: Int) throws {
        let request: NSFetchRequest<LeagueEntity> = LeagueEntity.fetchRequest()
        request.predicate = NSPredicate(format: "leagueKey == %d", leagueKey)

        if let entityToDelete = try context.fetch(request).first {
            context.delete(entityToDelete)
            try context.save()
        }
    }
}
