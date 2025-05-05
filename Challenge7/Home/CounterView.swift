//
//  CounterView.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/5/25.
//

import SwiftUI

struct CounterView: View {
    let days = 4
    let hours = 1
    let minutes = 12
    let seconds = 38

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Current Streak")
                        .font(.system(size: 12, weight: .semibold, design: .monospaced))
                    Text("Started on Feb 21, 2025")
                        .font(.system(size: 8, weight: .light, design: .monospaced))
                }

                Spacer()

                Button {
                    
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }

            HStack(spacing: 30) {
                timeComponent(value: days, label: "Days")
                timeComponent(value: hours, label: "Hour")
                timeComponent(value: minutes, label: "Minutes")
                timeComponent(value: seconds, label: "Seconds")
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(.separator), lineWidth: 1)
        )
        .shadow(radius: 3)
    }

    func timeComponent(value: Int, label: String) -> some View {
        VStack {
            Text("\(value)")
                .font(.system(size: 24, weight: .semibold, design: .monospaced))
            Text(label)
                .font(.system(size: 12, weight: .light, design: .monospaced))
        }
    }
}




#Preview {
    CounterView()
}
