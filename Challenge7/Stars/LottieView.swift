//
//  LottieView.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/9/25.
//
import SwiftUI
import Lottie

struct LottiePlayerView: View {
    @State private var playbackMode: LottiePlaybackMode = .paused
    
    var body: some View {
        HStack {
            LottieView(animation: LottieAnimation.named("test"))
                .playbackMode(playbackMode)
                .animationDidFinish { _ in
                    playbackMode = .paused
                }
            
            Button {
                playbackMode = .playing(.fromProgress(0, toProgress: 1, loopMode: .playOnce))
            } label: {
                Image(systemName: "play.fill")
            }
        }
    }
}



#Preview {
    LottiePlayerView()
}
