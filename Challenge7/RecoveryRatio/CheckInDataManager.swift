//
//  CheckInDataManager.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/15/25.
//

import Foundation

struct CheckInRecord: Codable {
    let date: Date
    let didGamble: Bool?
}

final class CheckInDataManager: ObservableObject {
    @Published var records: [CheckInRecord] = []

    private let storageKey = "CheckInRecords"

    init() {
        load()
        _ = NotificationManager.shared
    }

    func addRecord(for date: Date, didGamble: Bool?) {
        let newRecord = CheckInRecord(date: date, didGamble: didGamble)
        if let index = records.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: date) }) {
            records[index] = newRecord
        } else {
            records.append(newRecord)
        }
        save()

        NotificationManager.shared.cancelTodayNotification()

    }

    func scheduleCheckInReminder() {
        let today = Date()
        if !hasCheckedIn(for: today) {
            NotificationManager.shared.scheduleCheckInReminder(for: today)
        }
    }


    func hasCheckedIn(for date: Date) -> Bool {
        return records.contains { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }


    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([CheckInRecord].self, from: data) else { return }
        self.records = decoded
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(records) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }
}
