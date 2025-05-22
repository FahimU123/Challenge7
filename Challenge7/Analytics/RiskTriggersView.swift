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
        HStack {
            VStack(alignment: .leading, spacing: 20) {
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
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 35) {
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
            .padding(8)
            .background(Color.col)
            .cornerRadius(15)
        }
        .padding(.horizontal)
    }

    func triggerCard(icon: String, label: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(Color.text)
                .font(.system(size: 48))

            Text(label.uppercased())
                .font(.caption)
                .foregroundColor(Color.text)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.7)
                .truncationMode(.tail)
                .padding(.horizontal, 6)
                .allowsTightening(true)
                .textCase(.uppercase)
                .layoutPriority(1)
        }
        .frame(width: 150, height: 150)
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
