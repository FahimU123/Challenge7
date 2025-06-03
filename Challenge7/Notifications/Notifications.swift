//
//  Notifications.swift
//  Challenge7
//
//  Created by Saeed Mohamed on 5/28/25.
//

import Foundation
import UserNotifications

final class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {
        requestNotificationPermission()
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else {
                print("Notification permission denied.")
            }
        }
    }
    
    func scheduleCheckInReminder(for date: Date) {
        let calendar = Calendar.current

        let content = UNMutableNotificationContent()
        content.title = "Time to Check In"
        content.body = "Have you gambled today? It's time to check in."
        content.sound = .default

        guard let triggerDate = calendar.date(bySettingHour: 16, minute: 20, second: 0, of: date) else { return }
        let triggerComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: false)

        let identifier = "checkInReminder-\(triggerComponents.year!)-\(triggerComponents.month!)-\(triggerComponents.day!)"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Scheduled notification with ID: \(identifier)")
            }
        }
    }

    
    func cancelTodayNotification() {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        let identifier = "checkInReminder-\(components.year!)-\(components.month!)-\(components.day!)"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        print("Cancelled notification with identifier: \(identifier)")
    }
}
