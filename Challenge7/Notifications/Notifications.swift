//
//  Notifications.swift
//  Challenge7
//
//  Created by Saeed Mohamed on 5/28/25.
//

//import Foundation
//import UserNotifications
//
//final class NotificationManager {
//    static let shared = NotificationManager()
//
//    private init() {
//        requestNotificationPermission()
//    }
//
//    func requestNotificationPermission() {
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
//            if granted {
//                print("Notification permission granted.")
//            } else {
//                print("Notification permission denied.")
//            }
//        }
//    }
//
//    func scheduleCheckInReminder(for date: Date) {
//        let calendar = Calendar.current
//
//        let content = UNMutableNotificationContent()
//        content.title = "Time to Check In"
//        content.body = "Have you gambled today? It's time to check in."
//        content.sound = .default
//
//        let triggerDate = calendar.date(bySettingHour: 16, minute: 10, second: 0, of: date)!
//        let triggerComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate)
//        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: true)
//
//        let request = UNNotificationRequest(identifier: "checkInReminder", content: content, trigger: trigger)
//
//        UNUserNotificationCenter.current().add(request) { error in
//            if let error = error {
//                print("Error scheduling notification: \(error.localizedDescription)")
//            }
//        }
//    }
//
//    func cancelScheduledNotification() {
//        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["checkInReminder"])
//    }
//}

