//
//  Challenge7App.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/5/25.
//

import SwiftUI
import SwiftData

@main
struct Challenge7App: App {
    var body: some Scene {
        WindowGroup {
            TabBarView()
        }
        .modelContainer(for: Note.self)
    }
}
