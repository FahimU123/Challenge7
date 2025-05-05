//
//  AddNoteView.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/5/25.
//

import SwiftUI
import PhotosUI
import SwiftData
import AVKit

struct AddNoteView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var noteText: String = ""
    @State private var selectedImage: UIImage?
    @State private var selectedVideoURL: URL?
    
    @State private var showImagePicker = false
    @State private var showVideoPicker = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("New Note")
                    .font(.largeTitle)
                    .bold()
                
                TextEditor(text: $noteText)
                    .frame(height: 150)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray)
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
                    HStack {
                        Image(systemName: "video.fill")
                        Text(videoURL.lastPathComponent)
                            .lineLimit(1)
                        
                        Spacer()
                    }
                    .padding()
                    .background(Color.gray).opacity(0.2)
                    .cornerRadius(10)
                }
                
                HStack {
                    Button("Add Image") {
                        showImagePicker = true
                    }
                    
                    Spacer()
                    
                    Button("Add Video") {
                        showVideoPicker = true
                    }
                }
                
                Spacer()
                
                Button(action: saveNote) {
                    Text("Save Note")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
//            .navigationTitle("Add Note")
            .sheet(isPresented: $showImagePicker) {
                PhotoPicker(image: $selectedImage)
            }
            .sheet(isPresented: $showVideoPicker) {
                VideoPicker(videoURL: $selectedVideoURL)
            }
        }
    }
    
    func saveNote() {
        guard !noteText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || selectedImage != nil || selectedVideoURL != nil else {
            return
        }
        
        let imageData = selectedImage?.jpegData(compressionQuality: 0.8)
        
        let newNote = Note(text: noteText, imageData: imageData, videoURL: selectedVideoURL)
        modelContext.insert(newNote)
        
        
        dismiss()
    }
}

#Preview {
    AddNoteView()
}
