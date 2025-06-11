//
//  OnboardingView.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/14/25.
//

import SwiftUI


struct OnboardingPageContent: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String?
}

let onboardingContents: [OnboardingPageContent] = [
    OnboardingPageContent(title: "QUITTING GAMBLING ISN’T LINEAR.", subtitle: "SOME DAYS ARE STRONG. SOME ARE NOT."),
    OnboardingPageContent(title: "YOUR STREAK MIGHT BREAK...", subtitle: "BUT THAT DOESN'T MEAN YOU'RE STARTING FROM ZERO."),
    OnboardingPageContent(title: "YOU DON'T HAVE TO ANNOUNCE THIS TO ANYONE.", subtitle: "IF YOU FEEL SHAME, YOU CAN HIDE THE APP IN SETTINGS. RECOVERY IS YOURS—PRIVATE IF YOU WANT IT TO BE."),
    OnboardingPageContent(title: "TRACK YOUR RECOVERY RATIO.", subtitle: "SEE HOW MUCH OF YOUR TIME IS ACTUALLY GAMBLE-FREE—WEEKLY, MONTHLY, YEARLY."),
    OnboardingPageContent(title: "SLIPS REVEAL YOUR TRIGGERS.", subtitle: "WHEN YOU BREAK A STREAK, WE HELP YOU SPOT THE ‘WHY’—AND BUILD STRATEGIES AROUND IT."),
    OnboardingPageContent(title: "PROGRESS ISN’T ABOUT BEING FLAWLESS.", subtitle: "IT’S ABOUT SHOWING UP—AGAIN AND AGAIN."),
    OnboardingPageContent(title: "WELCOME TO DEADBET.", subtitle: "LET’S WALK YOUR RECOVERY PATH—WHATEVER IT LOOKS LIKE.")
]


struct OnboardingPageView: View {
    var onboadringContent: OnboardingPageContent
    @State private var isAnimating: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Text(onboadringContent.title)
                .font(.system(size: 24, weight: .bold))
//                .foregroundColor(.snow)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            if let subtitle = onboadringContent.subtitle {
                Text(subtitle)
                    .font(.title3)
//                    .foregroundColor(.primary.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            Spacer()
            Spacer()
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                isAnimating = true
            }
        }
        .padding(.horizontal, 20)
    }
}

struct StartButtonView: View {
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    
    
    var body: some View {
        Button(action: {
            
            isOnboarding = false
        }) {
            HStack(spacing: 8) {
                Text("Start")
                
                Image(systemName: "arrow.right.circle")
                    .imageScale(.large)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                Capsule().strokeBorder(Color.primary, lineWidth: 1.25)
            )
        }
//        .accentColor(Color.snow)
        .padding(.top, 40)
    }
}


struct OnBoardingView: View {
    @State private var selection = 0
    var onboardingContent: [OnboardingPageContent] = onboardingContents
    
    var body: some View {
        
        VStack {
            TabView(selection: $selection) {
                ForEach(onboardingContent.indices, id: \.self) { index in
                    OnboardingPageView(onboadringContent: onboardingContent[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .never))
            .padding(.vertical, 20)
            
           
            
            if selection == onboardingContent.count - 1 {
                StartButtonView()
                    .padding(.bottom, 40)

            } else {
                Text("SWIPE TO CONTINUE")
                    .padding(.bottom, 100)
            }
        }
    }
}
