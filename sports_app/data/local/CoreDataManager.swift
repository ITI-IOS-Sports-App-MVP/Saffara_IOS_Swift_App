//
//  CoreDataManager.swift
//  sports_app
//
//  Created by Thaowpsta Saiid on 25/05/2026.
//

import CoreData
import UIKit

class CoreDataManager: CoreDataManagerProtocol {
    static let shared = CoreDataManager()

    private let context = (UIApplication.shared.delegate as! AppDelegate)
        .persistentContainer.viewContext

    private init() {}

    func fetchFavorites() throws -> [League] {
        let request: NSFetchRequest<LeagueEntity> = LeagueEntity.fetchRequest()
        request.predicate = NSPredicate(format: "isFavorite == YES")
        let entities = try context.fetch(request)

        return entities.map { entity in
            League(
                leagueKey: Int(entity.leagueKey),
                leagueName: entity.leagueName,
                leagueLogo: entity.leagueLogo,
                leagueCountry: entity.leagueCountry,
                sportName: entity.sportName
            )
        }
    }

    func saveFavorite(league: League) throws {
        let request: NSFetchRequest<LeagueEntity> = LeagueEntity.fetchRequest()
        request.predicate = NSPredicate(
            format: "leagueKey == %d",
            league.leagueKey ?? 0
        )

        if let existingEntity = try context.fetch(request).first {
            existingEntity.isFavorite = true
        } else {
            let entity = LeagueEntity(context: context)
            entity.leagueKey = Int64(league.leagueKey ?? 0)
            entity.leagueName = league.leagueName
            entity.leagueLogo = league.leagueLogo
            entity.leagueCountry = league.leagueCountry
            entity.sportName = league.sportName
            entity.isFavorite = true
        }

        try context.save()
    }

    func deleteFavorite(leagueKey: Int) throws {
        let request: NSFetchRequest<LeagueEntity> = LeagueEntity.fetchRequest()
        request.predicate = NSPredicate(format: "leagueKey == %d", leagueKey)

        if let entity = try context.fetch(request).first {
            entity.isFavorite = false
            try context.save()
        }
    }

    func fetchCachedLeagues(for sportName: String) throws -> [League] {
        let request: NSFetchRequest<LeagueEntity> = LeagueEntity.fetchRequest()
        request.predicate = NSPredicate(format: "sportName == %@", sportName)

        let entities = try context.fetch(request)

        return entities.map { entity in
            League(
                leagueKey: Int(entity.leagueKey),
                leagueName: entity.leagueName,
                leagueLogo: entity.leagueLogo,
                leagueCountry: entity.leagueCountry,
                sportName: entity.sportName
            )
        }
    }

    func saveLeagues(_ leagues: [League], for sportName: String) throws {
        let fetchRequest: NSFetchRequest<LeagueEntity> =
            LeagueEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "sportName == %@ AND isFavorite == NO",
            sportName
        )

        let oldLeagues = try context.fetch(fetchRequest)
        for oldLeague in oldLeagues {
            context.delete(oldLeague)
        }

        for league in leagues {
            let checkRequest: NSFetchRequest<LeagueEntity> =
                LeagueEntity.fetchRequest()
            checkRequest.predicate = NSPredicate(
                format: "leagueKey == %d",
                league.leagueKey ?? 0
            )

            if let existing = try context.fetch(checkRequest).first {
                existing.leagueName = league.leagueName
                existing.leagueLogo = league.leagueLogo
                existing.leagueCountry = league.leagueCountry
            } else {
                let entity = LeagueEntity(context: context)
                entity.leagueKey = Int64(league.leagueKey ?? 0)
                entity.leagueName = league.leagueName
                entity.leagueLogo = league.leagueLogo
                entity.leagueCountry = league.leagueCountry
                entity.sportName = sportName
                entity.isFavorite = false
            }
        }

        if context.hasChanges {
            try context.save()
        }
    }

    func fetchCachedTeams(for leagueKey: Int) throws -> [Team] {
        let request: NSFetchRequest<TeamEntity> = TeamEntity.fetchRequest()
        request.predicate = NSPredicate(format: "leagueKey == %d", leagueKey)

        let entities = try context.fetch(request)

        return entities.map { entity in
            Team(
                teamKey: Int(entity.teamKey),
                teamName: entity.teamName,
                teamLogo: entity.teamLogo,
                playerKey: nil,
                playerName: nil,
                playerLogo: nil,
                playerImage: nil,
                players: nil
            )
        }
    }

    func saveTeams(_ teams: [Team], for leagueKey: Int) throws {
        let fetchRequest: NSFetchRequest<TeamEntity> = TeamEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "leagueKey == %d",
            leagueKey
        )

        let oldTeams = try context.fetch(fetchRequest)
        for old in oldTeams { context.delete(old) }

        for team in teams {
            let entity = TeamEntity(context: context)
            entity.leagueKey = Int64(leagueKey)
            entity.teamKey = Int64(team.teamKey ?? 0)
            entity.teamName = team.displayTeamName
            entity.teamLogo = team.displayTeamLogo
        }

        if context.hasChanges { try context.save() }
    }

    func fetchCachedEvents(for leagueKey: Int, type: String) throws -> [Event] {
        let request: NSFetchRequest<EventEntity> = EventEntity.fetchRequest()
        request.predicate = NSPredicate(
            format: "leagueKey == %d AND eventType == %@",
            leagueKey,
            type
        )

        let entities = try context.fetch(request)

        return entities.map { entity in
            Event(
                eventKey: Int(entity.eventKey),
                eventDate: entity.eventDate,
                eventTime: entity.eventTime,
                eventHomeTeam: entity.eventHomeTeam,
                eventAwayTeam: entity.eventAwayTeam,
                homeTeamLogo: entity.homeTeamLogo,
                awayTeamLogo: entity.awayTeamLogo,
                eventHomeTeamLogo: nil,
                eventAwayTeamLogo: nil,
                eventFirstPlayer: nil,
                eventSecondPlayer: nil,
                eventFirstPlayerLogo: nil,
                eventSecondPlayerLogo: nil,
                eventHomePlayer: nil,
                eventAwayPlayer: nil,
                eventFinalResult: entity.eventFinalResult,
                eventDateStart: nil,
                eventHomeFinalResult: nil,
                eventAwayFinalResult: nil
            )
        }
    }

    func saveEvents(_ events: [Event], for leagueKey: Int, type: String) throws
    {
        let fetchRequest: NSFetchRequest<EventEntity> =
            EventEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "leagueKey == %d AND eventType == %@",
            leagueKey,
            type
        )

        let oldEvents = try context.fetch(fetchRequest)
        for old in oldEvents { context.delete(old) }

        for event in events {
            let entity = EventEntity(context: context)
            entity.leagueKey = Int64(leagueKey)
            entity.eventType = type
            entity.eventKey = Int64(event.eventKey ?? 0)
            entity.eventDate = event.displayDate
            entity.eventTime = event.eventTime
            entity.eventHomeTeam = event.displayHomeName
            entity.eventAwayTeam = event.displayAwayName
            entity.homeTeamLogo = event.displayHomeLogo
            entity.awayTeamLogo = event.displayAwayLogo
            entity.eventFinalResult = event.eventFinalResult
        }

        if context.hasChanges { try context.save() }
    }
}
