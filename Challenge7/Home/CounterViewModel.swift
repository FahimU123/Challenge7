//
//  CounterViewModel.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/10/25.
//

import Foundation

final class CounterViewModel: ObservableObject {
    
    @Published private var startDate: Date {
        didSet {
            UserDefaults.standard.set(startDate, forKey: "startDate")
        }
    }

    @Published var checkin: Bool {
        didSet {
            UserDefaults.standard.set(checkin, forKey: "checkin")
        }
    }

    @Published var now: Date = Date()

    private var timer: Timer?

    init() {
        let savedDate = UserDefaults.standard.object(forKey: "startDate") as? Date
        let initialStartDate = savedDate ?? Date()
        let savedCheckin = UserDefaults.standard.bool(forKey: "checkin")

        self.startDate = initialStartDate
        self.checkin = savedCheckin

        if savedDate == nil {
            UserDefaults.standard.set(initialStartDate, forKey: "startDate")
        }

        startTimer()
    }

    func reset() {
        startDate = Date()
        checkin = true
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.now = Date()

            if !Calendar.current.isDateInToday(self.startDate) {
                self.checkin = false
                self.startDate = Date()
            }
        }
    }

    func seconds() -> Int {
        Int(now.timeIntervalSince(startDate)) % 60
    }

    func minutes() -> Int {
        (Int(now.timeIntervalSince(startDate)) / 60) % 60
    }

    func hours() -> Int {
        (Int(now.timeIntervalSince(startDate)) / 3600) % 24
    }

    func days() -> Int {
        Int(now.timeIntervalSince(startDate)) / 86400
    }
}
