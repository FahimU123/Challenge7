//
//  PlainCountervIew.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/10/25.
//

import SwiftUI

struct PlainCounterView: View {
    @ObservedObject var viewModel: CounterViewModel
    
    var body: some View {
        HStack(spacing: 16) {
            timeBlock(value: viewModel.days(), label: "D")
            timeBlock(value: viewModel.hours(), label: "H")
            timeBlock(value: viewModel.minutes(), label: "M")
            timeBlock(value: viewModel.seconds(), label: "S")
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Time since last action")
        .accessibilityValue("\(viewModel.days()) days, \(viewModel.hours()) hours, \(viewModel.minutes()) minutes, \(viewModel.seconds()) seconds")
    }
    
    func timeBlock(value: Int, label: String) -> some View {
        VStack {
            Text(String(format: "%02d", value))
                .font(.system(size: 24, weight: .bold, design: .default))
                .foregroundColor(.snow)
                .contentTransition(.numericText())
                .animation(.default, value: value)
                .accessibilityHidden(true)
            Text(label)
                .font(.caption2)
                .foregroundColor(.snow)
                .accessibilityHidden(true)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(String(format: "%02d", value)) \(label)")
    }
}

#Preview {
    PlainCounterView(viewModel: CounterViewModel())
}

