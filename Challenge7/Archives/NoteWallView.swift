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
import PhotosUI

struct NotesWallView: View {
    @Query(sort: \Note.createdAt, order: .reverse) var notes: [Note]
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var showingNewNoteSheet = false
    @State private var selectionMode = false
    @State private var selectedNotes: Set<Note> = []
    @State private var selectedPhotoItems: [PhotosPickerItem] = []
    @State private var activatePhotosPicker = false
    @State private var selectedNote: Note? = nil
    
    @State private var showFullscreen = false
    @State private var selectedNoteIndex: Int = 0

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
                            .foregroundStyle(Color.snow)
                            .font(.title)
                    }
                    .padding(.leading)

                    Text("Why I'm Doing This")
                        .font(
                            .system(size: 24, weight: .medium, design: .default)
                        )
                        .padding(.leading)
                        .popoverTip(tip)

                    Spacer()

                    Menu {
                        Button {
                            activatePhotosPicker = true
                        } label: {
                            Label("Add Photo", systemImage: "photo")
                        }

                        Button {
                            showingNewNoteSheet = true
                        } label: {
                            Label("Add New Note", systemImage: "note.text")
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(Color.snow)
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
                                .contentShape(Rectangle())
                            
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

                            if selectionMode {
                                Image(systemName: selectedNotes.contains(note) ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(selectedNotes.contains(note) ? .blue : .gray)
                                    .font(.title2)
                                    .padding(8)
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
            .photosPicker(
                isPresented: $activatePhotosPicker,
                selection: $selectedPhotoItems,
                maxSelectionCount: 15,
                matching: .images,
                photoLibrary: .shared()
            )
            .onChange(of: selectedPhotoItems) { newItems in
                Task {
                    await processPhotoItems(newItems)
                }
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

    private func processPhotoItems(_ items: [PhotosPickerItem]) async {
        for item in items {
            do {
                if let data = try await item.loadTransferable(type: Data.self) {
                    let newNote = Note(text: "", imageData: data)
                    modelContext.insert(newNote)
                    continue
                }

                if let url = try await item.loadTransferable(type: URL.self) {
                    let fileManager = FileManager.default
                    let docsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
                    let newURL = docsURL.appendingPathComponent(url.lastPathComponent)

                    if !fileManager.fileExists(atPath: newURL.path) {
                        try fileManager.copyItem(at: url, to: newURL)
                    }

                    let newNote = Note(text: "", imageData: nil)
                    modelContext.insert(newNote)
                }

            } catch {
                print("Failed to process picker item: \\(error)")
            }
        }

        try? modelContext.save()
    }
}

let previewContainer: ModelContainer = {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Note.self, configurations: config)
    Task { @MainActor in
        Note.samples.forEach { container.mainContext.insert($0) }
    }
    return container
}()

#Preview {
    NotesWallView()
        .modelContainer(previewContainer)
}
