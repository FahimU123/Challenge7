//
//  ContentView.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/18/25.
//

import SwiftUI

struct ContentView: View {

    @AppStorage("isOnboarding") private var isOnboarding: Bool?
    @State private var showHome: Bool = false
    
    var body: some View {
        ZStack {
            if showHome {
                HomeView()
                    .ignoresSafeArea(.all)
                   
            } else {
    
                OnBoardingView()

            }
        }
        .onAppear {
            if isOnboarding == false {
                showHome = true
            } else {
                showHome = false
            }
        }
        .onChange(of: isOnboarding) {
            withAnimation(.easeInOut(duration: 0.6)) {
                if isOnboarding == false {
                    showHome = true
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(CheckInDataManager())
}
