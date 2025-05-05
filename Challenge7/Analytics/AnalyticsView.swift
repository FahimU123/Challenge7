//
//  AnalyticsView.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/5/25.
//

import SwiftUI
import Charts
import Foundation

// Example chart data arrays
let whatsWorkingCharts: [AnalyticsChartItem] = [
    AnalyticsChartItem(title: "WHAT'S WORKING?", subtitle: "Where you did your best", chartData: WhatsWorkingChartData),
    AnalyticsChartItem(title: "CONSISTENCY", subtitle: "Most consistent behavior", chartData: ConsistencyChartData)
]

let whatsNotWorkingCharts: [AnalyticsChartItem] = [
    AnalyticsChartItem(title: "WHAT'S NOT WORKING?", subtitle: "What can be improved", chartData: WhatsNotWorkingChartData),
    AnalyticsChartItem(title: "OBSTACLES", subtitle: "Common struggles", chartData: ObstacleChartData)
]

struct AnalyticsView: View {
    @State private var workingIndex = 0
    @State private var notWorkingIndex = 0
    @State private var selectedTimeRange: String = "Weekly"
    let timeRanges = ["Weekly", "Monthly", "Yearly"]
    
    var filteredWorkingCharts: [AnalyticsChartItem] {
        switch selectedTimeRange {
        case "Weekly":
            return weeklyWorkingCharts
        case "Yearly":
            return yearlyWorkingCharts
        default:
            return monthlyWorkingCharts
        }
    }
    
    var filteredNotWorkingCharts: [AnalyticsChartItem] {
        switch selectedTimeRange {
        case "Weekly":
            return weeklyNotWorkingCharts
        case "Yearly":
            return yearlyNotWorkingCharts
        default:
            return monthlyNotWorkingCharts
        }
    }

    var body: some View {
        ZStack {
            Color(.gray)
                .ignoresSafeArea()

            VStack(spacing: 12) {
                Menu {
                    ForEach(timeRanges, id: \.self) { range in
                        Button(action: {
                            selectedTimeRange = range
                        }) {
                            Text(range)
                        }
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text(selectedTimeRange)
                            .font(.title2)
                            .fontWeight(.bold)
                            .fontDesign(.monospaced)
                            .foregroundColor(.black)
                        Image(systemName: "chevron.down.circle.fill")
                            .foregroundColor(.black)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.top)

            // Top Half
                let workingItem = filteredWorkingCharts[workingIndex]

                VStack(alignment: .leading, spacing: 10) {
                    Text(workingItem.title)
                        .font(.system(size: 20, weight: .semibold, design: .monospaced))
                    Text(workingItem.subtitle)
                        .font(.body)
                        .foregroundColor(.black.opacity(0.6))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)

                ZStack {
                    HStack(alignment: .center) {
                        Button(action: {
                            if workingIndex > 0 { workingIndex -= 1 }
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .frame(width: 44, height: 44)
                                .background(Circle().fill(Color.black))
                        }
                        .padding(.horizontal, 8)

                        TabView(selection: $workingIndex) {
                            ForEach(0..<filteredWorkingCharts.count, id: \.self) { index in
                                ChartView(data: filteredWorkingCharts[index].chartData)
                                    .frame(width: 230, height: 230)
                                    .tag(index)
                            }
                        }
                        .frame(height: 230)
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        .padding(.vertical, 4)
                        .animation(.easeInOut, value: workingIndex)

                        Button(action: {
                            if workingIndex < filteredWorkingCharts.count - 1 { workingIndex += 1 }
                        }) {
                            Image(systemName: "chevron.right")
                                .foregroundColor(.white)
                                .frame(width: 44, height: 44)
                                .background(Circle().fill(Color.black))
                        }
                        .padding(.horizontal, 8)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 230)
                    .padding(.horizontal)
                }
                .offset(y: -8)

                Divider()
                    
        // Bottom Half
                let notWorkingItem = filteredNotWorkingCharts[notWorkingIndex]

                VStack(alignment: .leading, spacing: 10) {
                    Text(notWorkingItem.title)
                        .font(.system(size: 20, weight: .semibold, design: .monospaced))
                    Text(notWorkingItem.subtitle)
                        .font(.body)
                        .foregroundColor(.black.opacity(0.6))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)

                ZStack {
                    HStack(alignment: .center) {
                        Button(action: {
                            if notWorkingIndex > 0 { notWorkingIndex -= 1 }
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .frame(width: 44, height: 44)
                                .background(Circle().fill(Color.black))
                        }
                        .padding(.horizontal, 8)

                        TabView(selection: $notWorkingIndex) {
                            ForEach(0..<filteredNotWorkingCharts.count, id: \.self) { index in
                                ChartView(data: filteredNotWorkingCharts[index].chartData)
                                    .frame(width: 230, height: 230)
                                    .tag(index)
                            }
                        }
                        .frame(height: 230)
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        .padding(.vertical, 4)
                        .animation(.easeInOut, value: notWorkingIndex)

                        Button(action: {
                            if notWorkingIndex < filteredNotWorkingCharts.count - 1 { notWorkingIndex += 1 }
                        }) {
                            Image(systemName: "chevron.right")
                                .foregroundColor(.white)
                                .frame(width: 44, height: 44)
                                .background(Circle().fill(Color.black))
                        }
                        .padding(.horizontal, 8)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 230)
                    .padding(.horizontal)
                }
                .offset(y: -8)
                Spacer()
            }
            .padding(.top, 44)
        }
    }
}

#Preview {
    AnalyticsView()
}
