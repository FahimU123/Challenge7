//
//  CounterViewModel.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/10/25.
//

import Foundation

@Observable
class CounterViewModel {
    private var startDate = Date()
    private var timer: Timer?

    var seconds = 0
    var minutes = 0
    var hours = 0
    var days = 0

    var lastActionDate: Date? = nil

    var hasPerformedToday: Bool {
        guard let last = lastActionDate else { return false }
        return Calendar.current.isDateInToday(last)
    }

    init() {
        startTimer()
    }

    func reset() {
        startDate = Date()
        lastActionDate = Date()
        updateTime()
    }

    private func updateTime() {
        let diff = Int(Date().timeIntervalSince(startDate))
        seconds = diff % 60
        minutes = (diff / 60) % 60
        hours = (diff / 3600) % 24
        days = diff / 86400
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.updateTime()
        }
    }
}
