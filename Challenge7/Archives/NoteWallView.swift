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
    @Environment(\.colorScheme) var colorScheme
    @State private var showingNewNoteSheet = false
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var randomNote: Note? {
            notes.randomElement()
        }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(Color.primary)
                            .font(.title)
                    }
                    
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
                            .foregroundStyle(Color.primary)
                            .font(.system(size: 35))
                            .fontWeight(.ultraLight)
                            .padding()
                    }
                }
                ScrollView {
                    LazyVGrid(columns: columns, /*spacing: 20*/ spacing: 10) {
                        ForEach(notes) { note in
                            NoteCardView(note: note)
                                .contextMenu {
                                    Button(role: .destructive) {
                                        deleteNote(note)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                        }
                    }
                    .padding()
                }
            }
            .sheet(isPresented: $showingNewNoteSheet) {
                AddNoteView()
            }
        }
    }
    
    private func deleteNote(_ note: Note) {
        modelContext.delete(note)
        try? modelContext.save()
    }
}

#Preview {
//    NotesWallView()
//        .modelContainer(for: Note.self)
    
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Note.self, configurations: config)
        let context = container.mainContext
        
        Note.samples.forEach { context.insert($0) }
        
        return NotesWallView()
            .modelContainer(container)
    } catch {
        return Text("Failed to load preview: \(error.localizedDescription)")
    }
}
