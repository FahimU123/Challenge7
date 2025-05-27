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

struct AddNoteView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var noteText: String = ""
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("New Note")
                    .font(.system(size: 36, weight: .medium, design: .default))
                    .fontWidth(.condensed)
                    .fontWeight(.medium)

                TextEditor(text: $noteText)
                    .frame(height: 150)
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
        let trimmedText = noteText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
        
        let newNote = Note(text: trimmedText, imageData: nil)
        modelContext.insert(newNote)
        
        dismiss()
    }
}

#Preview {
    AddNoteView()
}
