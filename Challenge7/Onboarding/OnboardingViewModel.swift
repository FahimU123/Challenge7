//
//  OnboardingViewModel.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/14/25.
//

import Foundation

class OnboardingViewModel: ObservableObject {
    @Published var currentIndex: Int = 0

    let screens: [OnboardingScreen] = [
        OnboardingScreen(
            title: "QUITTING GAMBLING ISN’T \n LINEAR.",
            subtitle: "SOME DAYS ARE STRONG. SOME ARE NOT."
        ),
        OnboardingScreen(
            title: "YOUR STREAK MIGHT BREAK...",
            subtitle: "BUT THAT DOESN'T MEAN \n YOU'RE STARTING FROM ZERO."
        ),
        OnboardingScreen(
            title: "TRACK YOUR RECOVERY RATIO.",
            subtitle: "SEE HOW MUCH OF YOUR TIME \n IS ACTUALLY GAMBLE-FREE—DAILY,\n WEEKLY, MONTHLY."
        ),
        OnboardingScreen(
            title: "EVEN IF YOU SLIP,\n YOU CAN STILL SEE GROWTH.",
            subtitle: "STILL SEE HEALING. STILL BE PROUD."
        ),
        OnboardingScreen(
            title: "PROGRESS ISN’T ABOUT BEING FLAWLESS.",
            subtitle: "IT’S ABOUT SHOWING UP—AGAIN AND AGAIN."
        ),
        OnboardingScreen(
            title: "WELCOME TO HAVEN.",
            subtitle: "LET’S WALK YOUR RECOVERY\n  PATH—WHATEVER IT LOOKS LIKE."
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

