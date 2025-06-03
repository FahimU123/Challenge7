//
//  Challenge7App.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/5/25.
//

import SwiftData
import TipKit

@main
struct Challenge7App: App {
    @StateObject var checkInManager = CheckInDataManager()
    @State private var currentDay = Calendar.current.startOfDay(for: Date())

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(checkInManager)
                .onAppear {
                    checkInManager.scheduleCheckInReminder()
                    startDateObserver()
                }
        }
        .modelContainer(for: [Note.self, CheckInEntry.self])
    }

    init() {
        try? Tips.configure()
    }

    func startDateObserver() {
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            let today = Calendar.current.startOfDay(for: Date())
            if currentDay != today {
                currentDay = today
                checkInManager.scheduleCheckInReminder()
                print("New day detected: scheduled today's check-in reminder.")
            }
        }
    }
}
