//
//  Tips.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/14/25.
//

import Foundation
import TipKit

struct AddToArchiveTip: Tip {
    var title: Text {
        Text("Add a Personal Reminder")
    }
    
    var message: Text? {
        Text("Tap this button to save a note, or image that reminds you why you're choosing to quit gambling.")
    }
    
    var image: Image? {
        Image(systemName: "star")
    }
}

struct ChartTip: Tip {
    var title: Text {
        Text("Unlock Your Recovery Ratio")
    }

    var message: Text? {
        Text("Check in daily to activate your Recovery Ratio chart and track your progress over time.")
    }

    var image: Image? {
        Image(systemName: "chart.bar.fill")
    }
}
