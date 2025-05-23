//
//  OnboardingView.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/14/25.
//

import SwiftUI
import ConcentricOnboarding

struct OnboardingView: View {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    let onFinished: () -> Void

    var body: some View {
        ConcentricOnboardingView(pageContents: [
            (AnyView(OnboardingPageView(
                    title: "QUITTING GAMBLING ISN’T LINEAR.",
                    subtitle: "SOME DAYS ARE STRONG. SOME ARE NOT."
                )), .ripple),

                (AnyView(OnboardingPageView(
                    title: "YOUR STREAK MIGHT BREAK...",
                    subtitle: "BUT THAT DOESN'T MEAN YOU'RE STARTING FROM ZERO."
                )), .col),

                (AnyView(OnboardingPageView(
                    title: "YOU DON'T HAVE TO ANNOUNCE THIS TO ANYONE.",
                    subtitle: "IF YOU FEEL SHAME, YOU CAN HIDE THE APP IN SETTINGS. RECOVERY IS YOURS—PRIVATE IF YOU WANT IT TO BE."
                )), .uhhh),

                (AnyView(OnboardingPageView(
                    title: "TRACK YOUR RECOVERY RATIO.",
                    subtitle: "SEE HOW MUCH OF YOUR TIME IS ACTUALLY GAMBLE-FREE—WEEKLY, MONTHLY, YEARLY."
                )), .purple),

                (AnyView(OnboardingPageView(
                    title: "SLIPS REVEAL YOUR TRIGGERS.",
                    subtitle: "WHEN YOU BREAK A STREAK, WE HELP YOU SPOT THE ‘WHY’—AND BUILD STRATEGIES AROUND IT."
                )), .next),

                (AnyView(OnboardingPageView(
                    title: "PROGRESS ISN’T ABOUT BEING FLAWLESS.",
                    subtitle: "IT’S ABOUT SHOWING UP—AGAIN AND AGAIN."
                )), .pls),

                (AnyView(OnboardingPageView(
                    title: "WELCOME TO HAVEN.",
                    subtitle: "LET’S WALK YOUR RECOVERY PATH—WHATEVER IT LOOKS LIKE."
                )), .blue)
            ])
        .nextIcon("chevron.right")
        .didGoToLastPage {
            onFinished()
            hasSeenOnboarding = true
        }
    }
}


struct OnboardingPageView: View {
    let title: String
    let subtitle: String?

    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            Text(title)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color.text)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.title3)
                    .foregroundColor(Color.text)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            Spacer()
        }
    }
}

