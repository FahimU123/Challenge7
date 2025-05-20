//
//  ButtonStyle.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/19/25.
//

import SwiftUI

struct MyButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                Capsule()
                    .foregroundColor(configuration.isPressed ? Color.primary.opacity(0.7) : Color.primary)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 3.0)
            .animation(.spring(), value: configuration.isPressed)
    }
}

extension Button {
    func myButtonStyle() -> some View {
        self.buttonStyle(MyButtonStyle())
    }
}
