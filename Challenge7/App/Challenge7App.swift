//
//  Challenge7App.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/5/25.
//

import SwiftUI
import Lottie
import SwiftData

@main
struct Challenge7App: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(for: Note.self)
    }
}
