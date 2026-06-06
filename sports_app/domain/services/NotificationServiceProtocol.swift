//
//  NotificationServiceProtocol.swift
//  sports_app
//
//  Created by Thaowpsta Saiid on 04/06/2026.
//

import Foundation
import UserNotifications

protocol NotificationServiceProtocol {
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void)
    func scheduleNotification(title: String, body: String, date: Date, identifier: String)
}
