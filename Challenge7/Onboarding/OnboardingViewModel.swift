//
//  OnboardingViewModel.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/14/25.
//

import Foundation

final class OnboardingViewModel: ObservableObject {
    @Published var currentIndex: Int = 0

    let screens: [OnboardingScreen] = [
        OnboardingScreen(
            title: "QUITTING GAMBLING ISN’T LINEAR.",
            subtitle: "SOME DAYS ARE STRONG. SOME ARE NOT."
        ),
        OnboardingScreen(
            title: "YOUR STREAK MIGHT BREAK...",
            subtitle: "BUT THAT DOESN'T MEAN YOU'RE STARTING FROM ZERO."
        ),
        OnboardingScreen(
            title: "YOU DON'T HAVE TO ANNOUNCE THIS TO ANYONE.",
            subtitle: "IF YOU FEEL SHAME, YOU CAN HIDE THE APP IN SETTINGS. RECOVERY IS YOURS—PRIVATE IF YOU WANT IT TO BE."
        ),
        OnboardingScreen(
            title: "TRACK YOUR RECOVERY RATIO.",
            subtitle: "SEE HOW MUCH OF YOUR TIME IS ACTUALLY GAMBLE-FREE—WEEKLY, MONTHLY, YEARLY."
        ),
        OnboardingScreen(
            title: "SLIPS REVEAL YOUR TRIGGERS.",
            subtitle: "WHEN YOU BREAK A STREAK, WE HELP YOU SPOT THE ‘WHY’—AND BUILD STRATEGIES AROUND IT."
        ),
        OnboardingScreen(
            title: "PROGRESS ISN’T ABOUT BEING FLAWLESS.",
            subtitle: "IT’S ABOUT SHOWING UP—AGAIN AND AGAIN."
        ),
        OnboardingScreen(
            title: "WELCOME TO HAVEN.",
            subtitle: "LET’S WALK YOUR RECOVERY PATH—WHATEVER IT LOOKS LIKE."
        )
    ]

    var isLastScreen: Bool {
        currentIndex == screens.count - 1
    }

    func next() {
        if !isLastScreen {
            currentIndex += 1
        }
    }
}

