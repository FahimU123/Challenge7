//
//  Challenge7App.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/5/25.
//

import SwiftUI
import Lottie
import SwiftData
import TipKit

@main
struct Challenge7App: App {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    @StateObject var checkInManager = CheckInDataManager()

    var body: some Scene {
        WindowGroup {
            if hasSeenOnboarding {
                HomeView()
                    .environmentObject(checkInManager)
                    .modelContainer(for: [Note.self, CheckInEntry.self])
            } else {
                OnboardingView()
                    .environmentObject(checkInManager)
            }
        }
        .modelContainer(for: Note.self)
    }

    init() {
        try? Tips.configure()
    }
}
