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
                        RoundedRectangle(cornerRadius: 32)
                            .stroke(Color.black)
                            .opacity(0.5)
                    )
                
                Button(action: saveNote) {
                    Text("Save Note")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundStyle(.white)
                        .cornerRadius(32)
                }
                Spacer()
            }
            .padding()
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
        
        dismiss()
    }
}

#Preview {
    AddNoteView()
}
