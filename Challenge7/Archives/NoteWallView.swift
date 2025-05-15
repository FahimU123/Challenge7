//
//  NoteWallView.swift
//  Challenge7
//
//  Created by Davaughn Williams on 5/5/25.
//

import SwiftData
import SwiftUI
import TipKit

struct NotesWallView: View {
    @Query var notes: [Note]
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var showingNewNoteSheet = false


    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    let tip = AddToArchiveTip()

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
                    .padding(.leading)

                    Text("Why I'm Doing This")
                        .font(
                            .system(size: 24, weight: .medium, design: .default)
                        )
                        .fontWidth(.condensed)
                        .fontWeight(.medium)
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
                    .popoverTip(tip)
                }
                ScrollView {
                    HStack(alignment: .top, spacing: 10) {
        
                        LazyVStack(spacing: 10) {
                            ForEach(
                                notes.enumerated().filter { $0.offset % 2 == 0 }
                                    .map { $0.element }
                            ) { note in
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

                        // Second Column
                        LazyVStack(spacing: 10) {
                            ForEach(
                                notes.enumerated().filter { $0.offset % 2 == 1 }
                                    .map { $0.element }
                            ) { note in
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
        let container = try ModelContainer(
            for: Note.self,
            configurations: config
        )
        let context = container.mainContext

        Note.samples.forEach { context.insert($0) }

        return NotesWallView()
            .modelContainer(container)
    } catch {
        return Text("Failed to load preview: \(error.localizedDescription)")
    }
}
