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
import Liquid

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
            
            Liquid()
                .frame(width: 370, height: 330)
                .foregroundColor(.col)
            
                .opacity(0.3)
            
            Liquid()
                .frame(width: 350, height: 310)
                .foregroundColor(.col)
                .opacity(0.6)
            
            Liquid(samples: 5)
                .frame(width: 320, height: 290)
                .foregroundColor(.col)
            
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
    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    var body: some View {
        ZStack {
            let progress = 1.0 - timeRemaining / activeTime
            
            Circle()
                .fill(ringColor)
                .frame(width: ringSize + 20, height: ringSize + 20)
                .opacity(timerStart ? 0.2 + 0.5 * progress : 0)
                .scaleEffect(timerStart ? 1.1 + 0.3 * progress : 1.0)
                .blur(radius: timerStart ? 4 + 16 * progress : 0)
                .animation(.easeOut(duration: 0.5), value: progress)
            
            ZStack {
                
                Circle()
                    .fill(Color.black)
                    .frame(width: ringSize * 1.1, height: ringSize * 1.1)
                    .offset(y: 4)
                
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [ringColor, ringColor.opacity(0.9)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.3), lineWidth: 2)
                    )
                    .shadow(radius: 6)
                    .frame(width: ringSize, height: ringSize)
                    .scaleEffect(timerStart ? 0.88 : 1.0)
                    .shadow(color: ringColor.opacity(timerStart ? 0.6 : 0), radius: timerStart ? 10 : 0)
                    .animation(.easeInOut(duration: 0.2), value: timerStart)
                    .overlay(
                        Text(icon)
                            .font(.system(size: 22, weight: .heavy))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.6), radius: 2, x: 1, y: 1)
                    )
            }
        }
        .frame(width: ringSize + 20, height: ringSize + 20)
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

#Preview {
    CounterView(viewModel: CounterViewModel(), showLottieScreen: .constant(false))
        .environmentObject(CheckInDataManager())
}
