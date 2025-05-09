//
//  NoteWallView.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/5/25.
//

import SwiftUI
import SwiftData

struct NotesWallView: View {
    @Query var notes: [Note]
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var showingNewNoteSheet = false
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var randomNote: Note? {
            notes.randomElement()
        }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack {
                HStack {
                    Text("Why I'm doing this")
                        .font(.system(size: 24, design: .monospaced))
                        .fontWeight(.semibold)
                        .bold()
                        .padding(.leading)
                    
                    Spacer()
                    
                    Button {
                        showingNewNoteSheet = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(.white)
                            .font(.system(size: 35))
                            .fontWeight(.ultraLight)
                            .padding()
                    }
                }
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(notes) { note in
                            NoteCardView(note: note)
                        }
                    }
                    .padding()
                }
            }
            .sheet(isPresented: $showingNewNoteSheet) {
                AddNoteView()
            }
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 28))
                    .foregroundStyle(.white)
            }
        }
    }
}

#Preview {
    NotesWallView()
        .modelContainer(for: Note.self)
}
