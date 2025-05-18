//
//  ContentView.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/18/25.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    @State private var showHome: Bool = false

    var body: some View {
        ZStack {
            if showHome {
                HomeView()
                    .transition(.move(edge: .trailing).combined(with: .opacity))
            } else {
                OnboardingView(onFinished: {
                    withAnimation(.easeInOut(duration: 0.6)) {
                        showHome = true
                        hasSeenOnboarding = true
                    }
                })
                .transition(.move(edge: .leading).combined(with: .opacity))
            }
        }
        .onAppear {
            if hasSeenOnboarding {
                showHome = true
            }
        }
    }
}



#Preview {
    ContentView()
}
