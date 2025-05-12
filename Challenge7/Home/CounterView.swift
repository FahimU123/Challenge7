//
//  CounterView.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/5/25.
//

import SwiftUI
import Lottie
import AVFoundation

struct IndicatorView: View {
    var progress: CGFloat
    let ringSize: CGFloat
    let lineWidth: CGFloat
    let ringColor: Color
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    ringColor.opacity(0.3),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .frame(width: ringSize, height: ringSize)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    ringColor,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .frame(width: ringSize, height: ringSize)
        }
        .rotationEffect(.degrees(-90))
    }
}


struct SurveyView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.mint, .teal, .blue],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Text("🎯 Quick Survey")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                Text("Thank you for being honest. Reflecting is the first step toward control. We'll check in again tomorrow.")
                    .multilineTextAlignment(.center)
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.horizontal)
                
                Button(action: {
                    dismiss()
                }) {
                    Text("Done")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 40)
            }
            .padding()
        }
    }
}


struct LongPressToActionButton: View {
    var viewModel: CounterViewModel
    var onAction: () -> Void
    var ringColor: Color
    var icon: String
    
    @State private var timerStart = false
    @State private var timeRemaining: CGFloat = 2.0
    @State private var actionPerformed = false
    
    private let activeTime: CGFloat = 2.0
    private let ringSize: CGFloat = 80
    private let lineWidth: CGFloat = 8
    
    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            IndicatorView(
                progress: (activeTime - timeRemaining) / activeTime,
                ringSize: ringSize,
                lineWidth: lineWidth,
                ringColor: ringColor
            )
            
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundStyle(.white.opacity(timerStart ? 0.5 : 1.0))
        }
        .frame(width: ringSize, height: ringSize)
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !timerStart {
                        timerStart = true
                        actionPerformed = false
                    }
                }
                .onEnded { _ in
                    timerStart = false
                    timeRemaining = activeTime
                }
        )
        .onReceive(timer) { _ in
            if timerStart {
                if timeRemaining > 0 {
                    withAnimation(.linear(duration: 0.05)) {
                        timeRemaining -= 0.05
                    }
                } else if !actionPerformed {
                    actionPerformed = true
                    onAction()
                    timerStart = false
                    timeRemaining = activeTime
                }
            }
        }
    }
}


struct CheckedInView: View {
    var body: some View {
        VStack {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 40))
                .foregroundColor(.green)
            Text("You’ve checked in today!")
                .foregroundColor(.black)
                .font(.subheadline)
        }
    }
}

struct CounterView: View {
    @ObservedObject var viewModel: CounterViewModel
    @Binding var showLottieScreen: Bool

    @State private var showSurvey = false
    @State private var surveyCompleted = false

    var body: some View {
        ZStack {
           
            Circle()
                .fill(LinearGradient(colors: [.red, .orange], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 300, height: 300)
                .shadow(radius: 10)

            VStack(spacing: 12) {
              
                timeDisplay

                if !viewModel.checkin {
                    VStack(spacing: 18) {
                        Text("DID YOU GAMBLE TODAY?")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)

                        HStack(spacing: 30) {
                            
                            LongPressToActionButton(
                                viewModel: viewModel,
                                onAction: {
                                    viewModel.checkin = true
                                    withAnimation {
                                        showLottieScreen = true
                                    }
                                },
                                ringColor: .red,
                                icon: "xmark"
                            )
                            LongPressToActionButton(
                                viewModel: viewModel,
                                onAction: {
                                    viewModel.reset()
                                    showSurvey = true
                                },
                                ringColor: .green,
                                icon: "checkmark"
                            )
                        }
                    }
                } else {
                    Text("See you tomorrow 👋")
                        .font(.footnote)
                        .foregroundColor(.white)
                        .padding(.top, 4)
                }
            }
            .padding(16)
        }
        .fullScreenCover(isPresented: $showSurvey, onDismiss: {
            viewModel.reset()
            surveyCompleted = true
        }) {
            SurveyView()
        }
    }

    var timeDisplay: some View {
        HStack(spacing: 16) {
            timeBlock(value: viewModel.days(), label: "D")
            timeBlock(value: viewModel.hours(), label: "H")
            timeBlock(value: viewModel.minutes(), label: "M")
            timeBlock(value: viewModel.seconds(), label: "S")
        }
    }

    func timeBlock(value: Int, label: String) -> some View {
        VStack(spacing: 2) {
            Text(String(format: "%02d", value))
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
            Text(label)
                .font(.caption2)
                .foregroundColor(.white.opacity(0.85))
        }
    }
}
