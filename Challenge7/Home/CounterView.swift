//
//  CounterView.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/5/25.
//

import SwiftUI
import UIKit

@Observable
class CounterViewModel {
    private var startDate: Date = Date()
    private var timer: Timer?
    
    init() {
        startTimer()
    }
    
    func reset() {
        startDate = Date()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.startDate = self.startDate
        }
    }
    
    func seconds() -> Int {
        Int(Date().timeIntervalSince(startDate)) % 60
    }
    
    func minutes() -> Int {
        (Int(Date().timeIntervalSince(startDate)) / 60) % 60
    }
    
    func hours() -> Int {
        (Int(Date().timeIntervalSince(startDate)) / 3600) % 24
    }
    
    func days() -> Int {
        Int(Date().timeIntervalSince(startDate)) / 86400
    }
}

struct CounterView: View {
    var viewModel: CounterViewModel
    
    var body: some View {
        ZStack {
            Circle().fill(LinearGradient(colors: [.red, .orange], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 300, height: 300)
           
            
            VStack {
                timeDisplay
                Text("DID YOU GAMBLE TODAY?")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                
                HStack {
                    Button {
                        
                    } label: {
                        Text("YES")
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color.red)
                            .cornerRadius(20)
                    }
                    Button {
                        viewModel.reset()
                    } label: {
                        Text("NO")
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color.green)
                            .cornerRadius(20)
                    }
                }
            }
        }
    }
    
    var timeDisplay: some View {
        HStack(spacing: 25) {
            timeBlock(value: viewModel.days(), label: "DAYS")
            timeBlock(value: viewModel.hours(), label: "HOUR")
            timeBlock(value: viewModel.minutes(), label: "MINUTES")
            timeBlock(value: viewModel.seconds(), label: "SECONDS")
        }
        .padding(.bottom, 10)
    }
    
    func timeBlock(value: Int, label: String) -> some View {
        VStack {
            Text(String(format: "%02d", value))
                .font(.system(size: 24, weight: .bold, design: .default))
                .foregroundColor(.black)
            Text(label)
                .font(.caption2)
                .foregroundColor(.black)
        }
    }
}

struct PlainCounterView: View {
    var viewModel: CounterViewModel
    
    var body: some View {
        HStack {
            timeBlock(value: viewModel.days(), label: "DAYS")
            timeBlock(value: viewModel.hours(), label: "HOUR")
            timeBlock(value: viewModel.minutes(), label: "MINUTES")
            timeBlock(value: viewModel.seconds(), label: "SECONDS")
            
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
    CounterView(viewModel: CounterViewModel())
}
