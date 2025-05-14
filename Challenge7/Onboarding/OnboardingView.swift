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

    var body: some View {
        ZStack {
            Color.col
                .ignoresSafeArea()
            
            LottieView(animation: .named("leaves"))
                            .looping()
                            .ignoresSafeArea()
//                            .opacity(0.4)

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
                Button(action: {
                    if viewModel.isLastScreen {
                        hasSeenOnboarding = true
                    } else {
                        viewModel.next()
                        let screen = viewModel.screens[viewModel.currentIndex]
                        typeTitle(screen.title)
                        typeSubtitle(screen.subtitle ?? "")
                    }
                }) {
                    Text(viewModel.isLastScreen ? "START" : "TAP TO CONTINUE")
                        .font(.caption)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 24)
                        .foregroundColor(.text)
                        .background(Color.snow)
                        .cornerRadius(20)
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
        if position == 0 { titleText = "" }
        if position < fullText.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                titleText.append(fullText[position])
                typeTitle(fullText, at: position + 1)
            }
        }
    }

    func typeSubtitle(_ fullText: String, at position: Int = 0) {
        if position == 0 { subtitleText = "" }
        if position < fullText.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
                subtitleText.append(fullText[position])
                typeSubtitle(fullText, at: position + 1)
            }
        }
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
