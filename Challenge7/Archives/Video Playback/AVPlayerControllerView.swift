//
//  AVPlayerControllerView.swift
//  Challenge7
//
//  Created by Davaughn Williams on 5/22/25.
//


import SwiftUI
import AVFoundation
import AVKit

struct AVPlayerControllerView: UIViewControllerRepresentable {
    let url: URL
    let width: CGFloat

    @State static var heightCache: [URL: CGFloat] = [:] // Optional: cache aspect ratios

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let player = AVPlayer(url: url)
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = true
        controller.videoGravity = .resizeAspect
        controller.view.backgroundColor = .clear
        controller.view.clipsToBounds = true
        controller.view.layer.cornerRadius = 16 // fix rounded corners

        context.coordinator.player = player
        return controller
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        guard let track = AVAsset(url: url).tracks(withMediaType: .video).first else { return }
        let size = track.naturalSize.applying(track.preferredTransform)
        let aspectRatio = abs(size.height / size.width)
        let height = width * aspectRatio

        uiViewController.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        uiViewController.view.layer.cornerRadius = 16
        uiViewController.view.clipsToBounds = true
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator {
        var player: AVPlayer?
    }
}

import SwiftUI
import AVFoundation

struct ResizableAVPlayerCard: View {
    let url: URL
    let width: CGFloat

    @State private var aspectRatio: CGFloat = 9.0 / 16.0

    var body: some View {
        AVPlayerControllerView(url: url, width: width)
            .frame(width: width, height: width * aspectRatio)
            .onAppear {
                let asset = AVAsset(url: url)
                if let track = asset.tracks(withMediaType: .video).first {
                    let size = track.naturalSize.applying(track.preferredTransform)
                    let ratio = abs(size.height / size.width)
                    DispatchQueue.main.async {
                        self.aspectRatio = ratio
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}
