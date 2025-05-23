//
//  VideoPlaybackManager.swift
//  Challenge7
//
//  Created by Davaughn Williams on 5/22/25.
//


import Foundation
import AVFoundation

class VideoPlaybackManager {
    static let shared = VideoPlaybackManager()
    private var currentPlayer: AVPlayer?

    private init() {}

    func register(player: AVPlayer) {
        // Pause and reset old player
        if currentPlayer != nil && currentPlayer !== player {
            currentPlayer?.pause()
            currentPlayer?.seek(to: .zero)
        }
        currentPlayer = player
        currentPlayer?.play()
    }

    func stopCurrent() {
        currentPlayer?.pause()
        currentPlayer?.seek(to: .zero)
        currentPlayer = nil
    }
}