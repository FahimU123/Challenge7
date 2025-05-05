//
//  ChartData.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/5/25.
//

import Foundation
import SwiftUI

struct ChartEntry: Identifiable {
    let id = UUID()
    let category: String
    let value: Double
    let color: Color
}

struct AnalyticsChartItem {
    let title: String
    let subtitle: String
    let chartData: [ChartEntry]
}

//Base chart data used by all time ranges

let WhatsWorkingChartData: [ChartEntry] = [
    ChartEntry(category: "Boredom", value: 25, color: .blue),
    ChartEntry(category: "Loneliness", value: 35, color: .green),
    ChartEntry(category: "Payday", value: 40, color: .orange)
]

let WhatsNotWorkingChartData: [ChartEntry] = [
    ChartEntry(category: "Boredom", value: 25, color: .blue),
    ChartEntry(category: "Loneliness", value: 60, color: .green),
    ChartEntry(category: "Payday", value: 15, color: .orange)
]

let ConsistencyChartData: [ChartEntry] = [
    ChartEntry(category: "Gahook", value: 10, color: .blue),
    ChartEntry(category: "Tester", value: 25, color: .green),
    ChartEntry(category: "Wild", value: 75, color: .orange)
]

let ObstacleChartData: [ChartEntry] = [
    ChartEntry(category: "Smoking", value: 60, color: .blue),
    ChartEntry(category: "Gaming", value: 10, color: .green),
    ChartEntry(category: "Chess", value: 20, color: .orange)
]


// MARK: - Time Range Chart Data

// Weekly
let weeklyWorkingCharts: [AnalyticsChartItem] = [
    AnalyticsChartItem(title: "WHAT'S WORKING?", subtitle: "Where you did your best this week", chartData: WhatsWorkingChartData),
    AnalyticsChartItem(title: "CONSISTENCY", subtitle: "This week’s strengths by behavior", chartData: ConsistencyChartData)
]

let weeklyNotWorkingCharts: [AnalyticsChartItem] = [
    AnalyticsChartItem(title: "WHAT'S NOT WORKING?", subtitle: "What can be improved this week", chartData: WhatsNotWorkingChartData),
    AnalyticsChartItem(title: "OBSTACLES", subtitle: "Challenges faced this week", chartData: ObstacleChartData)
]

// Monthly
let monthlyWorkingCharts: [AnalyticsChartItem] = [
    AnalyticsChartItem(title: "WHAT'S WORKING?", subtitle: "Where you did your best this month", chartData: WhatsWorkingChartData),
    AnalyticsChartItem(title: "CONSISTENCY", subtitle: "This month’s strengths by behavior", chartData: ConsistencyChartData)
]

let monthlyNotWorkingCharts: [AnalyticsChartItem] = [
    AnalyticsChartItem(title: "WHAT'S NOT WORKING?", subtitle: "What can be improved this month", chartData: WhatsNotWorkingChartData),
    AnalyticsChartItem(title: "OBSTACLES", subtitle: "Challenges faced this month", chartData: ObstacleChartData)
]

// Yearly
let yearlyWorkingCharts: [AnalyticsChartItem] = [
    AnalyticsChartItem(title: "WHAT'S WORKING?", subtitle: "Where you did your best this year", chartData: WhatsWorkingChartData),
    AnalyticsChartItem(title: "CONSISTENCY", subtitle: "This year’s strengths by behavior", chartData: ConsistencyChartData)
]

let yearlyNotWorkingCharts: [AnalyticsChartItem] = [
    AnalyticsChartItem(title: "WHAT'S NOT WORKING?", subtitle: "What can be improved this year", chartData: WhatsNotWorkingChartData),
    AnalyticsChartItem(title: "OBSTACLES", subtitle: "Challenges faced this year", chartData: ObstacleChartData)
]
