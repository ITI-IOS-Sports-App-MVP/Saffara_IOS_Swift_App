//
//  NotificationService.swift
//  sports_app
//
//  Created by Thaowpsta Saiid on 04/06/2026.
//

import Foundation
import UserNotifications

protocol UserNotificationCenterProtocol {
    func requestAuthorization(options: UNAuthorizationOptions, completionHandler: @escaping (Bool, Error?) -> Void)
    func add(_ request: UNNotificationRequest, withCompletionHandler completionHandler: (((Error)?) -> Void)?)
}
extension UNUserNotificationCenter: UserNotificationCenterProtocol {}

class NotificationService: NotificationServiceProtocol {
    private let center: UserNotificationCenterProtocol
    
    init(center: UserNotificationCenterProtocol = UNUserNotificationCenter.current()) {
        self.center = center
    }
    
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        center.requestAuthorization(
            options: [.alert, .sound, .badge],
            completionHandler: completion
        )
    }
    
    func scheduleNotification(title: String, body: String, date: Date, identifier: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let components = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: date
        )
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        center.add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error.localizedDescription)")
            } else {
                print("Successfully scheduled alert for: \(date)")
            }
        }
    }
}
