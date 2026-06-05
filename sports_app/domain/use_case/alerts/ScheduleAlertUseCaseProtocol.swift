//
//  ScheduleAlertUseCaseProtocol.swift
//  sports_app
//
//  Created by Thaowpsta Saiid on 04/06/2026.
//

import Foundation

protocol ScheduleAlertUseCaseProtocol {
    func execute(sportName: String, eventName: String, date: Date)
}
