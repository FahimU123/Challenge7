//
//  CounterViewModel.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/10/25.
//
//

import Foundation

final class CounterViewModel: ObservableObject {
    
    @Published private var startDate: Date {
        didSet {
            UserDefaults.standard.set(startDate, forKey: "startDate")
        }
    }
    
    @Published var checkin: Bool = false {
        didSet {
            UserDefaults.standard.set(checkin, forKey: "checkin")
        }
    }
    
    @Published private var lastCheckinDate: Date {
        didSet {
            UserDefaults.standard.set(lastCheckinDate, forKey: "lastCheckinDate")
        }
    }
    
    @Published var now: Date = Date()
    
    private var timer: Timer?
    
    init() {
        let savedDate = UserDefaults.standard.object(forKey: "startDate") as? Date
        let savedCheckin = UserDefaults.standard.bool(forKey: "checkin")
        let savedCheckinDate = UserDefaults.standard.object(forKey: "lastCheckinDate") as? Date ?? Date.distantPast
        
        self.startDate = savedDate ?? Date()
        self.checkin = savedCheckin
        self.lastCheckinDate = savedCheckinDate
        
        startTimer()
    }
    
    func reset() {
        startDate = Date()
    }
    
    func checkedIn() {
        checkin = true
        lastCheckinDate = Date()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.now = Date()
            
            if !Calendar.current.isDateInToday(self.lastCheckinDate) {
                self.checkin = false
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
