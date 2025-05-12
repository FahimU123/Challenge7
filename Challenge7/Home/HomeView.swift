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

struct HomeView: View {
    @State private var sheetOffset: CGFloat = 300
    @State private var dragOffset: CGFloat = 100
    private let expandedOffset: CGFloat = 50
    private let collapsedOffset: CGFloat = 400

    @State private var sharedViewModel = CounterViewModel()
    @State private var showLottieScreen = false
    @State private var audioPlayer: AVAudioPlayer?
    @State private var hapticEngine: CHHapticEngine?

    private var isExpanded: Bool {
        sheetOffset <= expandedOffset + 50
    }

    var body: some View {
        ZStack {
            Color(.systemBackground).edgesIgnoringSafeArea(.all)

            if showLottieScreen {
                ZStack {
                    LinearGradient(colors: [.pink, .orange, .yellow, .green, .blue, .purple],
                                   startPoint: .topLeading, endPoint: .bottomTrailing)
                        .ignoresSafeArea()

                    LottieView(animation: LottieAnimation.named("test"))
                        .playbackMode(.playing(.fromProgress(0, toProgress: 1, loopMode: .playOnce)))
                        .frame(width: 300, height: 300)
                }
                .onAppear {
                    triggerEffects()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation {
                            showLottieScreen = false
                        }
                    }
                }
            } else {
                if !isExpanded {
                    StarShowerView()
                }

                VStack {
                    if !isExpanded {
                        CounterView(viewModel: sharedViewModel) 
//                            withAnimation {
//                                showLottieScreen = true
//                            }
//                        }
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
        let baseTime = 0.1
        for i in 0..<5 {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(i))

            let event = CHHapticEvent(eventType: .hapticTransient,
                                      parameters: [intensity, sharpness],
                                      relativeTime: baseTime * Double(i))
            events.append(event)
        }

        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try hapticEngine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play haptics: \(error.localizedDescription)")
        }
    }
}

#Preview {
    HomeView()
}
