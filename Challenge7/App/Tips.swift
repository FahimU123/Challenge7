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
        Text("Tap this button to save a note, video, or image that reminds you why you're choosing to quit gambling.")
    }
    var image: Image? {
        Image(systemName: "star")
    }
}
