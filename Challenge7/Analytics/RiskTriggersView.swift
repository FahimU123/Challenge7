//
//  ChartView.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/5/25.
//

import SwiftUI
import SwiftGlass

struct RiskTriggersView: View {
    let entry: CheckInEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("YOUR RISK TRIGGERS")
                .font(.headline)
                .foregroundColor(Color.text)

            let hasActivity = !entry.activityTags.isEmpty
            let hasLocation = !entry.locationTags.isEmpty
            let hasCompanions = !entry.companionTags.isEmpty

            if !hasActivity && !hasLocation && !hasCompanions {
                Text("You currently have no risk triggers.")
                    .foregroundColor(Color.text)
                    .font(.subheadline)
                    .padding(.top, 8)
            } else {
                HStack(spacing: 12) {
                    triggerCard(icon: "clock", label: entry.timestamp.formatted(date: .omitted, time: .shortened))

                    if let what = entry.activityTags.first, !what.isEmpty {
                        triggerCard(icon: "person", label: what.uppercased())
                    }

                    if let whereTag = entry.locationTags.first, !whereTag.isEmpty {
                        triggerCard(icon: "location", label: whereTag.uppercased())
                    }

                    if let who = entry.companionTags.first, !who.isEmpty {
                        triggerCard(icon: "person.3", label: who.uppercased())
                    }
                }
            }
        }
        .padding()
        .background(Color.col)
        .cornerRadius(20)
    }

    func triggerCard(icon: String, label: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(Color.text)
                .font(.system(size: 20))

            Text(label)
                .font(.caption)
                .foregroundColor(Color.text)
                .multilineTextAlignment(.center)
        }
        .frame(width: 70, height: 80)
//        .background(Color.col)
        .glass(
            shadowOpacity: 0.1,
            shadowRadius: 20
        )
    }
}

#Preview {
    let sampleEntry = CheckInEntry(
        timestamp: .now,
        activityTags: ["Working"],
        locationTags: ["Home"],
        companionTags: ["Alone"]
    )
    return RiskTriggersView(entry: sampleEntry)
}
