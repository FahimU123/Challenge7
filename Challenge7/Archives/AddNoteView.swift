//
//  AddNoteView.swift
//  Challenge7
//
//  Created by Davaughn Williams on 5/5/25.
//

import SwiftUI
import PhotosUI
import SwiftData
import AVKit
import ExyteMediaPicker

struct AddNoteView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var noteText: String = ""
    @FocusState private var isFocused: Bool
    @State private var selectedImage: UIImage?
    @State private var selectedVideoURL: URL?
    
    @State private var showImagePicker = false
    @State private var showVideoPicker = false
    @State private var showDefaultMediaPicker = false
    @State private var medias: [Media] = []
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("New Note")
                    .font(.system(size: 36, weight: .medium, design: .default))
                    .fontWidth(.condensed)
                    .fontWeight(.medium)
                // When New Note is tapped the keyboard then dismisses
                    .onTapGesture {
                        isFocused = false
                    }
                
                TextEditor(text: $noteText)
                    .frame(height: 150)
                    .focused($isFocused)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black)
                            .opacity(0.5)
                    )
                
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                        .cornerRadius(10)
                }
                
                if let videoURL = selectedVideoURL {
                    if let thumbnail = generateThumbnail(for: videoURL) {
                        Image(uiImage: thumbnail)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                            .cornerRadius(10)
                    }

                }
                
                HStack {
                    Button {
                        showImagePicker = true
                    } label: {
                        Text("Add Image")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .foregroundStyle(.white)
                            .cornerRadius(10)
                    }
                    
                    
                    Spacer()
                    
                    
                    Button {
                        showVideoPicker = true
                    } label: {
                        Text("Add Video")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .foregroundStyle(.white)
                            .cornerRadius(10)
                    }
                    
                    Button {
                        showDefaultMediaPicker = true
                    } label: {
                        Text("Add Media")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .foregroundStyle(.white)
                            .cornerRadius(10)
                    }
                }
                
                Spacer()
                
                Button(action: saveNote) {
                    Text("Save Note")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
//            .sheet(isPresented: $showImagePicker) {
//                PhotoPicker(image: $selectedImage)
//            }
            
            .sheet(isPresented: $showDefaultMediaPicker) {
                MediaPicker(
                    isPresented: $showDefaultMediaPicker,
                    onChange: { medias = $0 }
                )
            }
            
            .sheet(isPresented: $showVideoPicker) {
                VideoPicker(videoPath: Binding(
                    get: { selectedVideoURL?.path },
                    set: { newPath in selectedVideoURL = newPath.map { URL(fileURLWithPath: $0) } }
                ))
            }
        }
    }
    
    func saveNote() {
        guard !noteText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || selectedImage != nil || selectedVideoURL != nil || !medias.isEmpty else {
            return
        }

        let imageData = selectedImage?.jpegData(compressionQuality: 0.8)
        if imageData != nil || selectedVideoURL != nil || !noteText.isEmpty {
            let newNote = Note(text: noteText, imageData: imageData, videoPath: selectedVideoURL?.path)
            modelContext.insert(newNote)
        }

        Task {
            for media in medias {
                do {
                    switch media.type {
                    case .image:
                        if let imageData = try await media.getData() {
                            let newNote = Note(text: "", imageData: imageData, videoPath: nil)
                            modelContext.insert(newNote)
                        }
                    case .video:
                        let originalURL = try await media.getURL()
                        let fileManager = FileManager.default
                        let docsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
                        guard let unwrappedURL = originalURL else { continue }
                        let newURL = docsURL.appendingPathComponent(unwrappedURL.lastPathComponent)

                        do {
                            if !fileManager.fileExists(atPath: newURL.path) {
                                try fileManager.copyItem(at: unwrappedURL, to: newURL)
                            }
                            let newNote = Note(text: "", imageData: nil, videoPath: newURL.path)
                            modelContext.insert(newNote)
                        } catch {
                            print("Error copying video file: \(error)")
                        }
                    }
                } catch {
                    print("Error copying video file: \(error)")
                }
            }

            dismiss()
        }
    }
    
    func generateThumbnail(for url: URL) -> UIImage? {
        let asset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        imageGenerator.appliesPreferredTrackTransform = true
        
        let time = CMTime(seconds: 1.0, preferredTimescale: 600)
        
        do {
            let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            
            return UIImage(cgImage: cgImage)
        } catch {
            print("Thumbnail generation failed: \(error)")
            
            return nil
        }
    }

}

#Preview {
    AddNoteView()
}
