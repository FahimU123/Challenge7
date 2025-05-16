//
//  OnboardingView.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/14/25.
//

import SwiftUI
import Lottie

struct OnboardingView: View {
    @ObservedObject var viewModel = OnboardingViewModel()
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    @State private var titleText: String = ""
    @State private var subtitleText: String = ""
    @State private var titleTypingWorkItem: DispatchWorkItem?
    @State private var subtitleTypingWorkItem: DispatchWorkItem?

    var body: some View {
        ZStack {
            Color.col
                .ignoresSafeArea()
            
            LottieView(animation: .named("leaves"))
                    .looping()
                    .ignoresSafeArea()

            VStack(spacing: 100) {
                Spacer()

                Text(titleText)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.text)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)

                if !subtitleText.isEmpty {
                    Text(subtitleText)
                        .font(.title3)
                        .foregroundColor(.text)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                }

                Spacer()

                Text(viewModel.isLastScreen ? "START" : "TAP TO CONTINUE")
                        .font(.caption)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 24)
                        .foregroundColor(.text)
                        .background(Color.snow)
                        .cornerRadius(20)                    
            }
            
            .contentShape(Rectangle())
                    .onTapGesture {
                        if viewModel.isLastScreen {
                            hasSeenOnboarding = true
                        } else {
                            viewModel.next()
                            let screen = viewModel.screens[viewModel.currentIndex]
                            typeTitle(screen.title)
                            typeSubtitle(screen.subtitle ?? "")
                        }
                    }
        }
        

        .onAppear {
            let screen = viewModel.screens[viewModel.currentIndex]
            typeTitle(screen.title)
            typeSubtitle(screen.subtitle ?? "")
        }
    }

    func typeTitle(_ fullText: String, at position: Int = 0) {
        titleTypingWorkItem?.cancel()

        if position == 0 { titleText = "" }

        let workItem = DispatchWorkItem {
            if position < fullText.count {
                titleText.append(fullText[position])
                typeTitle(fullText, at: position + 1)
            }
        }
        titleTypingWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: workItem)
    }

    func typeSubtitle(_ fullText: String, at position: Int = 0) {
        subtitleTypingWorkItem?.cancel()

        if position == 0 { subtitleText = "" }

        let workItem = DispatchWorkItem {
            if position < fullText.count {
                subtitleText.append(fullText[position])
                typeSubtitle(fullText, at: position + 1)
            }
        }
        subtitleTypingWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02, execute: workItem)
    }
}

extension String {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}

#Preview {
    OnboardingView(viewModel: OnboardingViewModel())
}
