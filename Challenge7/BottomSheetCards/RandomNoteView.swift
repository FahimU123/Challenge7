//
//  RandomNoteView.swift
//  Challenge7
//
//  Created by Davaughn Williams on 5/9/25.
//

import SwiftUI
import SwiftData
import AVKit
import SwiftGlass

struct RandomNoteView: View {
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
                                .frame(width: 140, height: 118)
                                .clipped()
                        } else if let videoPath = note.videoPath {
                            let videoURL = URL(fileURLWithPath: videoPath)
                            VideoPlayer(player: AVPlayer(url: videoURL))
                                .scaledToFill()
                                .frame(width: 140, height: 110)
                        } else if let text = note.text {
                            Text(text)
                                .font(.system(size: 12, design: .default))
                                .foregroundColor(.text)
                                .lineLimit(3)
                                .frame(width: 140, height: 110)
                                .background(Color.col)
                                .glass(
                                    shadowOpacity: 0.1,
                                    shadowRadius: 20
                                )
                        } else {
                            Text("No content")
                                .font(.headline)
                                .frame(width: 140, height: 110)
                        }
                    } else {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 35))
                            .fontWeight(.ultraLight)
                            .padding()
                            .foregroundColor(.text)
                            .frame(width: 140, height: 110)
                            .background(Color.col)
                            .glass(
                                shadowOpacity: 0.1,
                                shadowRadius: 20
                            )
                            
                    }

                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color.text)
                        .padding(6)
                        .background(Color.snow)
                        .clipShape(Circle())
                        .offset(x: -12, y: 14)
                }
                
                Spacer()
            
            }
    
        }
        .padding()
        .frame(width: 140, height: 110)
        .cornerRadius(32)
        .onAppear {
            refreshRandomNote()
            startRandomTimer()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    func refreshRandomNote() {
        let validNotes = notes.filter { note in
            note.text != nil ||
            (note.imageData != nil && UIImage(data: note.imageData!) != nil) ||
            (note.videoPath != nil && FileManager.default.fileExists(atPath: note.videoPath!))
        }
        
        guard !validNotes.isEmpty else {
            currentNote = nil
            return
        }

        if let newNote = validNotes.randomElement(), newNote != currentNote {
            withAnimation {
                currentNote = newNote
            }
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
