//
//  ChartView.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/5/25.
//

import SwiftUI
import Charts

struct ChartView: View {
    let data: [ChartEntry]

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 8) {
                Chart(data) { entry in
                    SectorMark(
                        angle: .value("Value", entry.value),
                        angularInset: 1
                    )
                    .foregroundStyle(entry.color)
                }
                .frame(width: geo.size.width * 0.8, height: geo.size.width * 0.8)
                .chartLegend(.hidden)

                HStack(spacing: 16) {
                    ForEach(data, id: \.category) { entry in
                        HStack(spacing: 4) {
                            Circle()
                                .fill(entry.color)
                                .frame(width: 10, height: 10)
                            Text(entry.category)
                                .font(.caption)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .frame(width: geo.size.width, height: geo.size.height, alignment: .top)
        }
    }
}

#Preview {
    ChartView(data: WhatsWorkingChartData)
    ChartView(data: WhatsNotWorkingChartData)
}
