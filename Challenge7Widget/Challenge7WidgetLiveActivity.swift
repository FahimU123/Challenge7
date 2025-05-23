//
//  Challenge7WidgetLiveActivity.swift
//  Challenge7Widget
//
//  Created by Fahim Uddin on 5/23/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct Challenge7WidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct Challenge7WidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: Challenge7WidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension Challenge7WidgetAttributes {
    fileprivate static var preview: Challenge7WidgetAttributes {
        Challenge7WidgetAttributes(name: "World")
    }
}

extension Challenge7WidgetAttributes.ContentState {
    fileprivate static var smiley: Challenge7WidgetAttributes.ContentState {
        Challenge7WidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: Challenge7WidgetAttributes.ContentState {
         Challenge7WidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: Challenge7WidgetAttributes.preview) {
   Challenge7WidgetLiveActivity()
} contentStates: {
    Challenge7WidgetAttributes.ContentState.smiley
    Challenge7WidgetAttributes.ContentState.starEyes
}
