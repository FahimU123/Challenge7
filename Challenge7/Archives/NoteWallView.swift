//
//  NoteWallView.swift
//  Challenge7
//
//  Created by Davaughn Williams on 5/5/25.
//

import SwiftData
import SwiftUI
import TipKit
import WaterfallGrid

struct NotesWallView: View {
    //    @Query var notes: [Note]
    @Query(sort: \Note.createdAt, order: .reverse) var notes: [Note]
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var showingNewNoteSheet = false
    @State private var selectionMode = false
    @State private var selectedNotes: Set<Note> = []


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
                }
                if selectionMode {
                    Text("Tap notes to select. Tap trash to delete.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 4)
                }
                ScrollView {
                    WaterfallGrid(notes) { note in
                        ZStack(alignment: .topLeading) {
                            NoteCardView(note: note)
                                .allowsHitTesting(!selectionMode)
                            if selectionMode {
                                Image(systemName: selectedNotes.contains(note) ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(selectedNotes.contains(note) ? .blue : .gray)
                                    .font(.title2)
                                    .padding(8)
                            }
                        }
                        .onTapGesture {
                            if selectionMode {
                                if selectedNotes.contains(note) {
                                    selectedNotes.remove(note)
                                } else {
                                    selectedNotes.insert(note)
                                }
                            }
                        }
                        .onLongPressGesture {
                            if !selectionMode {
                                selectionMode = true
                            }
                            if selectedNotes.contains(note) {
                                selectedNotes.remove(note)
                            } else {
                                selectedNotes.insert(note)
                            }
                        }
                    }
                    .gridStyle(columnsInPortrait: 2, columnsInLandscape: 3, spacing: 8, animation: .easeInOut(duration: 0.5))
                    .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                    }
                HStack {
                    if selectionMode {
                        Button {
                            selectionMode = false
                            selectedNotes.removeAll()
                        } label: {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(Color.green)
                                .font(.system(size: 35))
                        }
                        
                        if !selectedNotes.isEmpty {
                            Button(role: .destructive) {
                                deleteSelectedNotes()
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundStyle(Color.red)
                                    .font(.system(size: 24))
                            }
                            .padding(.trailing)
                        }
                    }
                }

            }
            .sheet(isPresented: $showingNewNoteSheet) {
                AddNoteView()
            }
        }
    }


    private func deleteSelectedNotes() {
        for note in selectedNotes {
            modelContext.delete(note)
        }
        try? modelContext.save()
        selectedNotes.removeAll()
        selectionMode = false
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
