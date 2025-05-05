//
//  TabBarView.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/5/25.
//

import SwiftUI

struct TabBarView: View {

    init() {
        UITabBar.appearance().backgroundColor = UIColor.black
        UITabBar.appearance().unselectedItemTintColor = UIColor.white
    }

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                       
                }

            NotesWallView()
                .tabItem {
                    Label("Archive", systemImage: "book.fill")
                }

            HomeView()
                .tabItem {
                    Label("Account", systemImage: "clipboard.fill")
                }

            AnalyticsView()
                .tabItem {
                    Label("Analytics", systemImage: "chart.bar.fill")
                }
        }
        .accentColor(.orange)
    }
}

#Preview {
    TabBarView()
}
