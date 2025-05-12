//
//  PlainCountervIew.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/10/25.
//

import SwiftUI

struct PlainCounterView: View {
    var viewModel: CounterViewModel
    
    var body: some View {
        HStack {
            timeBlock(value: viewModel.days, label: "DAYS")
            timeBlock(value: viewModel.hours, label: "HOUR")
            timeBlock(value: viewModel.minutes, label: "MINUTES")
            timeBlock(value: viewModel.seconds, label: "SECONDS")
            
        }
    }
    
    func timeBlock(value: Int, label: String) -> some View {
        VStack {
            Text(String(format: "%02d", value))
                .font(.system(size: 24, weight: .bold, design: .default))
                .foregroundColor(.white)
            Text(label)
                .font(.caption2)
                .foregroundColor(.white)
        }
    }
}


#Preview {
    PlainCounterView(viewModel: CounterViewModel())
}
