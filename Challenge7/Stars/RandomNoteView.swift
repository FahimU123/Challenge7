//
//  RandomNoteView.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/9/25.
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
                if let note = currentNote {
                    if let imageData = note.imageData, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 140)
                            .clipped()
                    } else if let videoURL = note.videoURL {
                        VideoPlayer(player: AVPlayer(url: videoURL))
                            .frame(height: 88)
                    } else if let text = note.text {
                        Text(text)
                            .font(.body)
                            .lineLimit(3)
                    } else {
                        Text("No content")
                            .font(.headline)
                    }
                } else {
                    Text("Loading...")
                        .font(.subheadline)
                }
                
                Spacer()
                
            
            }
            Image(systemName: "arrow.up.left.and.arrow.down.right")
                .font(.caption)
//                .padding(6)
                .background(Color.white.opacity(0.6))
//                .foregroundColor(.white)
                .clipShape(Circle())
                .offset(x: 70)
//                .padding(6)
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
