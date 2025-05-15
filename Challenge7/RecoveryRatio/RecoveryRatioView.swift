//
//  RecoveryRatioView.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/14/25.
//

import SwiftUI
import Charts
import SwiftGlass

enum TimeFrame: String, CaseIterable, Identifiable {
    case weekly = "Weekly"
    case monthly = "Monthly"
    case yearly = "Yearly"

    var id: String { rawValue }

    var descriptiveLabel: String {
        switch self {
        case .weekly: return "THIS WEEK"
        case .monthly: return "THIS MONTH"
        case .yearly: return "THIS YEAR"
        }
    }
}

struct RecoveryRatioView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var dataManager: CheckInDataManager
    @State private var selectedTimeFrame: TimeFrame = .weekly

    private var soberPercentage: Int? {
        let records = filteredRecords()
        let total = records.count
        guard total > 0 else { return nil }

        let cleanCount = records.filter { $0.didGamble == false }.count
        let percentage = Double(cleanCount) / Double(total) * 100
        return Int(percentage.rounded())
    }

    private func filteredRecords() -> [CheckInRecord] {
        let now = Date()
        let calendar = Calendar.current

        return dataManager.records.filter { record in
            switch selectedTimeFrame {
            case .weekly:
                return calendar.dateComponents([.day], from: record.date, to: now).day ?? 0 < 7
            case .monthly:
                return calendar.dateComponents([.month], from: record.date, to: now).month ?? 0 < 1
            case .yearly:
                return calendar.dateComponents([.year], from: record.date, to: now).year ?? 0 < 1
            }
        }
    }

    private func pieData() -> [(label: String, count: Int)] {
        let records = filteredRecords()
        let clean = records.filter { $0.didGamble == false }.count
        let relapse = records.filter { $0.didGamble == true }.count
        let noCheckIn = records.filter { $0.didGamble == nil }.count

        return [("Clean", clean), ("Relapsed", relapse), ("No Check-In", noCheckIn)]
    }

    private func color(for label: String) -> Color {
        switch label {
        case "Clean": return .green
        case "Relapsed": return .red
        case "No Check-In": return .gray
        default: return .primary
            
        }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 32) {
                Text("RECOVERY RATIO")
                    .font(.system(size: 32, weight: .bold, design: .default))
                    .foregroundColor(.snow)
                    .padding(.top)

                VStack(spacing: 20) {
                    Picker("Time Frame", selection: $selectedTimeFrame) {
                        ForEach(TimeFrame.allCases) { frame in
                            Text(frame.rawValue).tag(frame)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, 32)

                    Chart(pieData(), id: \.label) { item in
                        SectorMark(
                            angle: .value("Count", item.count),
                            innerRadius: .ratio(0.5)
                        )
                        .foregroundStyle(by: .value("Status", item.label))
                    }
                    .chartForegroundStyleScale([
                        "Clean": Color.green,
                        "Relapsed": Color.red,
                        "No Check-In": Color.gray
                    ])
                    .chartLegend(.hidden)
                    .frame(height: 300)
                    .padding()

                    HStack(spacing: 24) {
                        ForEach(pieData(), id: \.label) { item in
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(color(for: item.label))
                                    .frame(width: 14, height: 14)
                                Text(item.label)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                    .padding(.top, 8)

                }
                .padding(.horizontal)

                VStack(spacing: 10) {
                    if let percentage = soberPercentage {
                        Text("YOU WERE")
                            .font(.system(size: 17, weight: .regular, design: .default))
                            .foregroundColor(.snow)
                        Text("\(percentage)% GAMBLING FREE")
                            .font(.system(size: 24, weight: .black, design: .default))
                            .foregroundColor(.snow)
                        Text(selectedTimeFrame.descriptiveLabel)
                            .font(.system(size: 17, weight: .regular, design: .default))
                            .foregroundColor(.snow)
                    } else {
                        Text("")
                    }
                }
                .padding(.top, 16)

                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }
}
