//
//  CounterView.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/5/25.
//

import SwiftUI
import Lottie
import AVFoundation
import SwiftGlass
import TipKit

struct CounterView: View {
    @ObservedObject var viewModel: CounterViewModel
    @Binding var showLottieScreen: Bool
    @EnvironmentObject var checkInManager: CheckInDataManager
    @State private var showSurvey = false
    @State private var surveyCompleted = false
    
    init(viewModel: CounterViewModel, showLottieScreen: Binding<Bool>) {
        self._viewModel = ObservedObject(initialValue: viewModel)
        self._showLottieScreen = showLottieScreen
    }
    
    let encouragementMessages = [
        "YOU SHOWED UP TODAY. THAT MATTERS. SHOW UP AGAIN TOMORROW.",
        "EACH CHECK-IN IS A WIN. LET’S GET ANOTHER ONE TOMORROW.",
        "COME BACK TOMORROW — YOUR FUTURE SELF WILL THANK YOU.",
        "SMALL STEPS BECOME STRONG HABITS. SEE YOU TOMORROW.",
        "ANOTHER DAY CLEAN. THAT’S NOT SMALL — THAT’S EVERYTHING.",
        "YOU’RE GROWING. KEEP GOING.",
        "CHECKING IN DAILY BUILDS YOUR STRENGTH.",
        "TOMORROW’S ANOTHER BRICK IN YOUR FOUNDATION.",
        "SEE YOU TOMORROW, LEGEND. 🌟"
    ]
    
    let checkInTip = CheckInTip()
    

    var dailyMessage: String {
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 0
        return encouragementMessages[dayOfYear % encouragementMessages.count]
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.col,
                            Color.col.opacity(0.6)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 300, height: 300)
                .glass(
                    radius: 150,
                    color: .clear,
                    material: .ultraThinMaterial,
                    gradientOpacity: 0.3,
                    shadowColor: .col,
                    shadowRadius: 10
                )
            
            VStack(spacing: 12) {
                timeDisplay
                    .popoverTip(checkInTip)
                
                if !viewModel.checkin {
                    VStack(spacing: 18) {
                        Text("DID YOU GAMBLE TODAY?")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.text)
                            .multilineTextAlignment(.center)
                        
                        HStack(spacing: 30) {
                            LongPressToActionButton(
                                viewModel: viewModel,
                                onAction: {
                                    viewModel.checkin = true
                                    checkInManager.addRecord(for: Date(), didGamble: false)
                                    withAnimation {
                                        showLottieScreen = true
                                    }
                                },
                                ringColor: .green,
                                icon: "NO"
                            )
                            LongPressToActionButton(
                                viewModel: viewModel,
                                onAction: {
                                    viewModel.reset()
                                    checkInManager.addRecord(for: Date(), didGamble: true)
                                    showSurvey = true
                                },
                                ringColor: .red,
                                icon: "YES"
                            )
                        }
                    }
                } else {
                    VStack {
                        Text(dailyMessage)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.text)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 12)
                            .transition(.opacity)
                    }
                    .padding(.top, 8)
                }
            }
            .padding(16)
        }
        .sheet(isPresented: $showSurvey, onDismiss: {
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
        VStack {
            Text(String(format: "%02d", value))
                .font(.system(size: 24, weight: .bold, design: .default))
                .foregroundColor(.text)
                .contentTransition(.numericText())
                .animation(.default, value: value)
            
            Text(label)
                .font(.system(size: 15, weight: .light, design: .default))
                .foregroundColor(.text)
        }
    }
}


struct IndicatorView: View {
    var progress: CGFloat
    let ringSize: CGFloat
    let lineWidth: CGFloat
    let ringColor: Color
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    ringColor.opacity(0.5),
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

    
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)

    var body: some View {
        ZStack {
            IndicatorView(
                progress: (activeTime - timeRemaining) / activeTime,
                ringSize: ringSize,
                lineWidth: lineWidth,
                ringColor: ringColor
            )

            Text(icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.text.opacity(timerStart ? 0.5 : 1.0))
        }
        .frame(width: ringSize, height: ringSize)
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !timerStart {
                        feedbackGenerator.prepare()
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
                    feedbackGenerator.impactOccurred()
                    feedbackGenerator.prepare()
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
