//
//  RecoveryRatioView.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/9/25.
//
// Models.swift

import SwiftUI
import Charts
import SwiftGlass
import TipKit

struct RecoveryRatioCardView: View {
    @Binding var showFullRecoveryRatioView: Bool
    @EnvironmentObject var checkInManager: CheckInDataManager
    @State private var selectedTimeFrame: TimeFrame = .weekly
    let chartTip = ChartTip()
    
    private func pieData() -> [(label: String, count: Int)] {
        let now = Date()
        let calendar = Calendar.current
        
        let records = checkInManager.records.filter { record in
            switch selectedTimeFrame {
            case .weekly:
                return calendar.dateComponents([.day], from: record.date, to: now).day ?? 0 < 7
            case .monthly:
                return calendar.dateComponents([.month], from: record.date, to: now).month ?? 0 < 1
            case .yearly:
                return calendar.dateComponents([.year], from: record.date, to: now).year ?? 0 < 1
            }
        }
        
        let clean = records.filter { $0.didGamble == false }.count
        let relapse = records.filter { $0.didGamble == true }.count
        let noCheckIn = records.filter { $0.didGamble == nil }.count
        
        return [("Clean", clean), ("Relapsed", relapse), ("No Check-In", noCheckIn)]
    }
    
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
        
        return checkInManager.records.filter { record in
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
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack {
                Button {
                    showFullRecoveryRatioView = true
                } label: {
                    HStack(spacing: 12) {
                        
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
                        .frame(width: 50, height: 70)
                        .clipShape(RoundedRectangle(cornerRadius: 32))
                        
                        if let percentage = soberPercentage {
                            Text("\(percentage)%")
                                .font(.system(size: 17, weight: .bold))
                                .foregroundColor(.text)
                                .fixedSize(horizontal: true, vertical: false)
                            
                        } else {
                            Text("")
                             
                            }
                        
                        Spacer()
                    }
                    .padding(.leading, 20)
                    .frame(width: 140, height: 110)
                    .background(Color.col)
                    .clipShape(RoundedRectangle(cornerRadius: 32))
                    .glass(shadowOpacity: 0.1, shadowRadius: 20)
                }
                .popoverTip(chartTip)
                .fullScreenCover(isPresented: $showFullRecoveryRatioView) {
                    RecoveryRatioView(dataManager: checkInManager)
                }
            }
            
            Image(systemName: "arrow.up.left.and.arrow.down.right")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Color.text)
                .padding(6)
                .background(Color.snow)
                .clipShape(Circle())
                .offset(x: -12, y: 10)
        }
    }
}
