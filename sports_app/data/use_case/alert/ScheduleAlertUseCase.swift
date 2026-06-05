//
//  ScheduleAlertUseCase.swift
//  sports_app
//
//  Created by Thaowpsta Saiid on 04/06/2026.
//

import Foundation

class ScheduleAlertUseCase: ScheduleAlertUseCaseProtocol {
    private let notificationService: NotificationServiceProtocol
    
    init(notificationService: NotificationServiceProtocol) {
        self.notificationService = notificationService
    }
    
    func execute(sportName: String, eventName: String, date: Date) {
        notificationService.requestAuthorization { [weak self] granted, _ in
            guard granted else {
                print("Notification permission denied.")
                return
            }
            
            let title = String(format: "alert_reminder_title".localized, sportName.capitalized)
            let body = String(format: "alert_reminder_body".localized, eventName)
            
            let uniqueId = UUID().uuidString
            
            self?.notificationService.scheduleNotification(
                title: title,
                body: body,
                date: date,
                identifier: uniqueId
            )
        }
    }
}
