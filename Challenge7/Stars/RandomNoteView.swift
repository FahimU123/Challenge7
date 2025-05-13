//
//  RandomNoteView.swift
//  Challenge7
//
//  Created by Davaughn Williams on 5/9/25.
//

import SwiftUI
import SwiftData
import AVKit

struct RandomNoteView: View {
//    var note: Note?
    @Query var notes: [Note]
    @State private var currentNote: Note?
    @State private var timer: Timer? = nil

    var body: some View {
        ZStack(alignment: .topLeading) {
            
            
            
            VStack(alignment: .leading) {
                ZStack(alignment: .topTrailing) {
                    if let note = currentNote {
                        if let imageData = note.imageData, let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 140, height: 110)
                                .clipped()
                            //                        } else if let videoURL = note.videoURL {
                        } else if let videoPath = note.videoPath {
                                let videoURL = URL(fileURLWithPath: videoPath)
                            VideoPlayer(player: AVPlayer(url: videoURL))
                                .scaledToFill()
                                .frame(width: 140, height: 110)
                        } else if let text = note.text {
                            Text(text)
                                .font(.system(size: 12, design: .monospaced))
                                .lineLimit(3)
                                .frame(width: 140, height: 110)
                        } else {
                            Text("No content")
                                .font(.headline)
                                .frame(width: 140, height: 110)
                        }
                    } else {
                        Text("Loading...")
                            .font(.subheadline)
                            .frame(width: 140, height: 110)
                    }

                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                        .font(.caption)
                        .padding(6)
                        .background(Color.white.opacity(0.6))
                        .clipShape(Circle())
                        .offset(x: -8, y: 8)
                }
                
                Spacer()
                
            
            }
            
        }
        .padding()
        .frame(width: 140, height: 110)
        .background(Color(.systemGray5))
        .cornerRadius(16)
        .shadow(radius: 4)
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
