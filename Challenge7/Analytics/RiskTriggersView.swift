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
            VStack(alignment: .leading, spacing: 35) {
                Text("YOUR RISK TRIGGERS")
                    .font(.headline)
                    .foregroundColor(Color.text)
                    .accessibilityAddTraits(.isHeader)

                let hasActivity = !entry.activityTags.isEmpty
                let hasLocation = !entry.locationTags.isEmpty
                let hasCompanions = !entry.companionTags.isEmpty

                if !hasActivity && !hasLocation && !hasCompanions {
                    Text("You currently have no risk triggers.")
                        .foregroundColor(Color.text)
                        .font(.subheadline)
                        .padding(.top, 8)
                } else {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 25) {
                        triggerCard(
                            icon: "clock",
                            label: entry.timestamp.formatted(date: .omitted, time: .shortened),
                            accessibilityLabel: "Time of check-in",
                            accessibilityValue: entry.timestamp.formatted(date: .omitted, time: .shortened)
                        )

                        if let what = entry.activityTags.first, !what.isEmpty {
                            triggerCard(
                                icon: "person",
                                label: what.uppercased(),
                                accessibilityLabel: "Activity",
                                accessibilityValue: what.uppercased()
                            )
                        }

                        if let whereTag = entry.locationTags.first, !whereTag.isEmpty {
                            triggerCard(
                                icon: "location",
                                label: whereTag.uppercased(),
                                accessibilityLabel: "Location",
                                accessibilityValue: whereTag.uppercased()
                            )
                        }

                        if let who = entry.companionTags.first, !who.isEmpty {
                            triggerCard(
                                icon: "person.3",
                                label: who.uppercased(),
                                accessibilityLabel: "Companions",
                                accessibilityValue: who.uppercased()
                            )
                        }
                    }
                    .accessibilityElement(children: .contain)
                }
            }
            .padding(24)
            .background(Color.col)
            .cornerRadius(32)
        }
        .padding(.horizontal)
        .frame(width: 370, height: 150)
        .padding(.top, 100)
    }

    func triggerCard(icon: String, label: String, accessibilityLabel: String, accessibilityValue: String? = nil) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(Color.text)
                .font(.system(size: 32))
                .accessibilityHidden(true)

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
                .accessibilityHidden(true)
        }
        .frame(width: 120, height: 100)
        .glass(
            shadowOpacity: 0.1,
            shadowRadius: 20
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityValue(accessibilityValue ?? "")
        .accessibilityHint("Represents a risk trigger.")
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
