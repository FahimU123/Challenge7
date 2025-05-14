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
                                .frame(width: 140, height: 118)
                                .clipped()
                            //                        } else if let videoURL = note.videoURL {
                        } else if let videoPath = note.videoPath {
                            let videoURL = URL(fileURLWithPath: videoPath)
                            VideoPlayer(player: AVPlayer(url: videoURL))
                                .scaledToFill()
                                .frame(width: 140, height: 110)
                        } else if let text = note.text {
                            Text(text)
                                .font(.system(size: 12, design: .default))
                                .lineLimit(3)
                                .frame(width: 140, height: 110)
                        } else {
                            Text("No content")
                                .font(.headline)
                                .frame(width: 140, height: 110)
                        }
                    } else {
                        Text("TAP TO ADD A NOTE")
                            .font(.system(size: 10, design: .default))
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
                        .foregroundColor(Color.snow)
                        .padding(6)
                        .background(Color.text)
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
