//
//  CounterView.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/5/25.
//

import SwiftUI
import Lottie
import AVFoundation



import SwiftUI

struct CounterView: View {
    @State var viewModel: CounterViewModel
    @State private var showSurvey = false

    var body: some View {
        ZStack {
            Circle()
                .fill(LinearGradient(colors: [Color.red, Color.orange], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 300, height: 300)

            VStack(spacing: 12) {
                timeDisplay

                Text("DID YOU GAMBLE TODAY?")
                    .font(.system(size: 14, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)

                if showSurvey {
                    SurveyView()
                } else {
                    HStack(spacing: 40) {
                        LongPressToActionButton(viewModel: viewModel) {
                            showSurvey = true
                        }

                        LongPressToActionButton(viewModel: viewModel) {
                            showSurvey = true
                        }
                    }
                }
            }
        }
    }

    var timeDisplay: some View {
        HStack(spacing: 25) {
            ForEach([
                ("DAYS", viewModel.days),
                ("HOUR", viewModel.hours),
                ("MINUTES", viewModel.minutes),
                ("SECONDS", viewModel.seconds)
            ], id: \.0) { label, value in
                VStack {
                    Text(String(format: "%02d", value))
                        .font(.system(size: 24, weight: .bold))
                    Text(label)
                        .font(.caption2)
                }
                .foregroundColor(.primary)
            }
        }
        .padding(.bottom, 10)
    }
}

struct LongPressToActionButton: View {
    var viewModel: CounterViewModel
    var onAction: () -> Void

    @State private var timerStart = false
    @State private var actionPerformed = false
    @State private var timeRemaining: CGFloat = .infinity

    let activeTime = 2.0
    private let ringSize: CGFloat = 80
    private let lineWidth: CGFloat = 12

    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    var body: some View {
        if viewModel.hasPerformedToday {
            Text("✅ Check back in tomorrow")
                .foregroundColor(.gray)
                .font(.caption)
        } else {
            ZStack {
                IndicatorView(progress: (activeTime - timeRemaining) / activeTime,
                              ringSize: ringSize,
                              lineWidth: lineWidth)
                .onLongPressGesture(minimumDuration: activeTime, perform: {
                    guard actionPerformed == false else { return }
                    timerStart = false
                    performAction()
                    actionPerformed = true
                }, onPressingChanged: { isPressing in
                    if timeRemaining < 0 { return }
                    if isPressing {
                        timerStart = true
                    } else {
                        timerStart = false
                        withAnimation {
                            timeRemaining = activeTime
                        }
                    }
                })

                Image(systemName: "hand.tap.fill")
                    .font(.system(size: ringSize / 3))
                    .foregroundStyle(.white.opacity(timerStart ? 0.6 : 1.0))
            }
            .onReceive(timer) { _ in
                if timerStart, timeRemaining > 0 {
                    withAnimation {
                        timeRemaining -= 0.1
                    }
                }
            }
            .onAppear {
                timeRemaining = activeTime
            }
        }
    }

    func performAction() {
        viewModel.reset()
        onAction()
    }
}

struct IndicatorView: View {
    var progress: CGFloat
    let ringSize: CGFloat
    let lineWidth: CGFloat

    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color.red.opacity(0.3),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .frame(width: ringSize, height: ringSize)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color.red,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .frame(width: ringSize, height: ringSize)
        }
        .rotationEffect(.degrees(-90))
    }
}

struct SurveyView: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("🎯 Quick Survey")
                .font(.headline)
            Text("Thanks for checking in! Come back tomorrow.")
                .font(.subheadline)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
    }
}
