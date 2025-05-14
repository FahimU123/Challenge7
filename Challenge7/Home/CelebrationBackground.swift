//
//  CelebrationBackground.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/13/25.
//

import SwiftUI
import ConfettiSwiftUI
import StoreKit

struct CelebrationBackground: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var animate = false
    @Environment(\.requestReview) var requestReview

    var body: some View {
        ZStack {
            RadialGradient(
                gradient: Gradient(colors: [
                    .clear,
                    colorScheme == .dark ? .purple.opacity(0.2) : .yellow.opacity(0.2)
                ]),
                center: .center,
                startRadius: 50,
                endRadius: 500
            )
            .background(colorScheme == .dark ? Color.black : Color.white)
            .ignoresSafeArea()

            ForEach(0..<5) { i in
                Circle()
                    .stroke(Color.ripple, lineWidth: 10)
                    .frame(width: animate ? CGFloat(100 + i * 60) : 0,
                           height: animate ? CGFloat(100 + i * 60) : 0)
                    .scaleEffect(animate ? 2.5 : 0.1)
                    .animation(
                        .easeOut(duration: 2.5).delay(Double(i) * 0.4),
                        value: animate
                    )
            }
        }
        .onAppear {
            animate = true
            ReviewManager.shared.incrementVisit()
            Task {
                await tryRequestReview()
            }
        }
    }

    @MainActor
    private func tryRequestReview() async {
        try? await Task.sleep(for: .seconds(3.5))
        if ReviewManager.shared.shouldRequestReview() {
            requestReview()
            ReviewManager.shared.resetCounts()
        }
    }
}

extension Color {
    static var random: Color {
        return Color(hue: Double.random(in: 0...1),
                     saturation: 0.7,
                     brightness: 1.0)
    }
}


#Preview {
    CelebrationBackground()
}

