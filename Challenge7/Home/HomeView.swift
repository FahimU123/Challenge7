//
//  HomeView.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/5/25.
//

import SwiftUI
import Lottie
import AVFoundation
import CoreHaptics
import ConfettiSwiftUI


struct HomeView: View {
    @State private var sheetOffset: CGFloat = 300
    @State private var dragOffset: CGFloat = 100
    private let expandedOffset: CGFloat = 50
    private let collapsedOffset: CGFloat = 400
    @State var trigger: Int = 0
    @State private var sharedViewModel = CounterViewModel()
    @State private var showLottieScreen = false
    @State private var audioPlayer: AVAudioPlayer?
    @State private var hapticEngine: CHHapticEngine?
    @Environment(\.colorScheme) var colorScheme
    @State private var animate = false
    
    private var isExpanded: Bool {
        sheetOffset <= expandedOffset + 50
    }
    
    var body: some View {
        ZStack {
            Color(.color)
                .opacity(0.3)
                .edgesIgnoringSafeArea(.all)
            
            RadialGradient(
                    gradient: Gradient(colors: [
                        Color.col.opacity(0.0),
                        Color.accentColor.opacity(0.2)
                    ]),
                    center: .center,
                    startRadius: 50,
                    endRadius: 300
                )
                .blur(radius: 20)
            
            if showLottieScreen {
                    CelebrationBackground()
                    .confettiCannon(
                        trigger: $trigger,
                        num: 50,
                        openingAngle: .degrees(0),
                        closingAngle: .degrees(360),
                        radius: 200,
                        hapticFeedback: true
                    )
                    LottieView(animation: LottieAnimation.named("test"))
                        .playbackMode(.playing(.fromProgress(0, toProgress: 1, loopMode: .playOnce)))
                        .frame(width: 300, height: 300)
                
                .onAppear {
                    triggerEffects()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation {
                            showLottieScreen = false
                        }
                        animate = true
                    }
                }
            } else {
                if !isExpanded {
                    StarShowerView()
                }
                
                VStack {
                    if !isExpanded {
                        CounterView(viewModel: sharedViewModel, showLottieScreen: $showLottieScreen)
                            .padding(.top, 60)
                    } else {
                        PlainCounterView(viewModel: sharedViewModel)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                
                BottomSheetView(
                    isExpanded: isExpanded,
                    viewModel: sharedViewModel
                )
                .offset(y: sheetOffset + dragOffset)
                .gesture(
                    DragGesture()
                        .onChanged { value in dragOffset = value.translation.height }
                        .onEnded { value in
                            if value.translation.height < -100 {
                                sheetOffset = expandedOffset
                            } else if value.translation.height > 100 {
                                sheetOffset = collapsedOffset
                            }
                            dragOffset = 0
                        }
                )
                .animation(.easeInOut, value: sheetOffset)
            }
        }
        .onAppear {
            prepareHaptics()
        }
    }
    
    func triggerEffects() {
        playSpreadingHaptics()
        trigger += 1
        
        if let soundURL = Bundle.main.url(forResource: "chime", withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.play()
            } catch {
                print("Sound playback failed: \(error)")
            }
        }
    }
    
    func prepareHaptics() {
        do {
            hapticEngine = try CHHapticEngine()
            try hapticEngine?.start()
        } catch {
            print("Haptic engine Creation Error: \(error.localizedDescription)")
        }
    }
    
    func playSpreadingHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        var events = [CHHapticEvent]()
        
        let rippleCount = 6
        let rippleDuration: TimeInterval = 1.5
        let rippleSpacing = rippleDuration / Double(rippleCount)
        
        for i in 0..<rippleCount {
            let relativeTime = Double(i) * rippleSpacing
            let intensityValue = Float(1.0 - (Double(i) / Double(rippleCount)))
            let sharpnessValue = Float(1.0 - (Double(i) / Double(rippleCount)))
            
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: intensityValue)
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpnessValue)
            
            let event = CHHapticEvent(eventType: .hapticTransient,
                                      parameters: [intensity, sharpness],
                                      relativeTime: relativeTime)
            events.append(event)
        }
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try hapticEngine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play enhanced haptics: \(error.localizedDescription)")
        }
    }
    
}

#Preview {
    HomeView()
}

