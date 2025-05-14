//
//  SurveyView.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/13/25.
//

import SwiftUI

struct SurveyView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color(.col)
                .ignoresSafeArea(edges: .all)

            LinearGradient(colors: [.mint.opacity(0.3), .blue.opacity(0.3)],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
            .blendMode(.overlay)
            .ignoresSafeArea()

            VStack(spacing: 24) {
                Text("Quick Survey")
                    .font(.largeTitle.bold())
                    .foregroundColor(.primary)

                Text("Thank you for being honest. Reflecting is the first step toward control. We'll check in again tomorrow.")
                    .multilineTextAlignment(.center)
                    .font(.headline)
                    .foregroundColor(.primary.opacity(0.9))
                    .padding(.horizontal)

                Button(action: { dismiss() }) {
                    Text("Done")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 40)
            }
            .padding()
        }
    }
}
#Preview {
    SurveyView()
}
