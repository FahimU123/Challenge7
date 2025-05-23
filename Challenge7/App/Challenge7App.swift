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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(checkInManager)
        }
        .modelContainer(for: [Note.self, CheckInEntry.self])
    }

    init() {
        try? Tips.configure()
    }
}
