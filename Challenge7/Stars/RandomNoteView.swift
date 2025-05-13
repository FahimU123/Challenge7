//
//  RandomNoteView.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/9/25.
//

import SwiftUI
import SwiftData
import AVKit
import SwiftGlass

struct RandomNoteView: View {
    @Query var notes: [Note]
    @State private var currentNote: Note?
    @State private var timer: Timer?

    var body: some View {
        ZStack(alignment: .topTrailing) {

            VStack(alignment: .leading, spacing: 8) {
                Group {
                    if let note = currentNote {
                        if let imageData = note.imageData, let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 70)
                                .clipped()
                                .cornerRadius(8)
                        } else if let videoURL = note.videoURL {
                            VideoPlayer(player: AVPlayer(url: videoURL))
                                .frame(height: 70)
                                .cornerRadius(8)
                        } else if let text = note.text {
                            Text(text)
                                .font(.footnote)
                                .lineLimit(3)
                                .foregroundColor(.primary)
                        } else {
                            Text("No content")
                                .font(.footnote.italic())
                                .foregroundColor(.secondary)
                        }
                    } else {
                        Text("Loading...")
                            .font(.footnote)
                            .foregroundColor(.text)
                            .padding(.bottom, 30)
                    }
                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                        .font(.caption2)
                        .padding(6)
                        .background(Color.text.opacity(0.7))
                        .clipShape(Circle())
                        .padding(.leading, 90)
                }

                Spacer()
            }


        }

        .padding(12)
        .frame(width: 140, height: 110)
        .background(Color.col)
        .glass(
            shadowOpacity: 0.1,
            shadowRadius: 20
        )
        
        .onAppear {
            refreshRandomNote()
            startRandomTimer()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }

    func refreshRandomNote() {
        if !notes.isEmpty {
            currentNote = notes.randomElement()
        }
    }

    func startRandomTimer() {
        timer?.invalidate()
        let interval = Double.random(in: 5...15)
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { _ in
            refreshRandomNote()
            startRandomTimer()
        }
    }
}


#Preview {
    RandomNoteView()
}


