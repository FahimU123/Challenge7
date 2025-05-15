//
//  AnalyticsView.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/5/25.
//

import SwiftUI
import Foundation
import SwiftData

@Model
class CheckInEntry {
    var timestamp: Date
    var activityTags: [String]
    var locationTags: [String]
    var companionTags: [String]

    init(timestamp: Date = .now,
         activityTags: [String],
         locationTags: [String],
         companionTags: [String]) {
        self.timestamp = timestamp
        self.activityTags = activityTags
        self.locationTags = locationTags
        self.companionTags = companionTags
    }
}

