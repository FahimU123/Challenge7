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
    @StateObject private var vm = NoteWallViewModel()

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
                    .accessibilityLabel("Dismiss notes wall")
                    .accessibilityHint("Closes the current view and returns to the previous screen.")
                    
                    Text("Why I'm Doing This")
                        .font(
                            .system(size: 24, weight: .medium, design: .default)
                        )
                        .padding(.leading)
                        .popoverTip(tip)
                        .accessibilityAddTraits(.isHeader)
                        .accessibilityLabel("Why I'm Doing This. Tap for information on organizing your notes.")
                    
                    Spacer()
                    
                    Menu {
                        Button {
                            vm.activatePhotosPicker = true
                        } label: {
                            Label("Add Photo", systemImage: "photo")
                        }
                        .accessibilityLabel("Add Photo button")
                        .accessibilityHint("Opens photo library to add an image note.")
                        
                        Button {
                            vm.showingNewNoteSheet = true
                        } label: {
                            Label("Add New Note", systemImage: "note.text")
                        }
                        .accessibilityLabel("Add New Note button")
                        .accessibilityHint("Opens a sheet to create a new text note.")
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(Color.snow)
                            .font(.system(size: 35))
                            .fontWeight(.ultraLight)
                            .padding()
                    }
                    .accessibilityLabel("Add new note options")
                    .accessibilityHint("Opens a menu to add a photo or a new text note.")
                }
                
                if vm.selectionMode {
                    Text("Tap notes to select. Tap trash to delete.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 4)
                        .accessibilityLabel("Selection mode active. Tap notes to select. Tap the trash icon to delete selected notes.")
                       
                }
                
                ScrollView {
                    if notes.count < 3 {
                        LazyVStack(spacing: 16) {
                            ForEach(notes) { note in
                                NoteGridCellView(
                                    note: note,
                                    isSelected: vm.selectedNotes.contains(note),
                                    selectionMode: vm.selectionMode,
                                    onTap: {
                                        if vm.selectionMode {
                                            vm.toggleSelection(for: note)
                                        } else {
                                            vm.selectedNote = note
                                        }
                                    },
                                    onLongPress: {
                                        if !vm.selectionMode {
                                            vm.selectionMode = true
                                        }
                                        vm.toggleSelection(for: note)
                                    }
                                )
                                .padding(.horizontal)
                                .accessibilityIdentifier("noteCell_\(note.id.uuidString)")
                            }
                        }
                    } else {
                        WaterfallGrid(notes) { note in
                            NoteGridCellView(
                                note: note,
                                isSelected: vm.selectedNotes.contains(note),
                                selectionMode: vm.selectionMode,
                                onTap: {
                                    if vm.selectionMode {
                                        vm.toggleSelection(for: note)
                                    } else {
                                        vm.selectedNote = note
                                    }
                                },
                                onLongPress: {
                                    if !vm.selectionMode {
                                        vm.selectionMode = true
                                    }
                                    vm.toggleSelection(for: note)
                                }
                            )
                            .accessibilityIdentifier("noteCell_\(note.id.uuidString)")
                        }
                        .gridStyle(columnsInPortrait: 2, columnsInLandscape: 3, spacing: 8)
                        .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                    }
                }
                .accessibilityLabel("Your notes grid")
                .accessibilityHint("Swipe left or right to navigate through notes. Long press a note to enter selection mode.")

                HStack(spacing: 16){
                    if vm.selectionMode {
                        Button(role: .destructive) {
                            vm.showDeleteConfirmation = true
                        } label: {
                            RoundedRectangle(cornerRadius: 32)
                                .fill(Color.red)
                                .frame(height: 50)
                                .frame(maxWidth: .infinity)
                                .overlay(
                                    Text("Delete")
                                        .font(.title3)
                                        .foregroundStyle(.white)
                                )
                        }
                        .accessibilityLabel("Delete selected notes")
                        .accessibilityHint("Deletes all notes currently selected.")
                        .disabled(vm.selectedNotes.isEmpty)
                        
                        Spacer()
                        
                        if !vm.selectedNotes.isEmpty {
                            Button {
                                vm.selectionMode = false
                                vm.selectedNotes.removeAll()
                            } label: {
                                RoundedRectangle(cornerRadius: 32)
                                    .fill(Color.blue)
                                    .frame(height: 50)
                                    .frame(maxWidth: .infinity)
                                    .overlay(
                                        Text("Done")
                                            .font(.title3)
                                            .foregroundStyle(.white)
                                    )
                            }
                            .confirmationDialog(
                                "Are you sure you want to delete the selected notes?",
                                isPresented: $vm.showDeleteConfirmation,
                                titleVisibility: .visible
                            ) {
                                Button("Delete", role: .destructive) {
                                    vm.deleteSelectedNotes(using: modelContext)
                                }
                                .accessibilityLabel("Confirm delete")
                                Button("Cancel" ,role: .cancel) { }
                                .accessibilityLabel("Cancel delete")
                            }
                            .accessibilityLabel("Done with selection")
                            .accessibilityHint("Exits selection mode and deselects all notes.")
                        }
                    }
                }
                .padding(.horizontal)
            }
            .sheet(isPresented: $vm.showingNewNoteSheet) {
                AddNoteView()
            }
            
            .fullScreenCover(item: $vm.selectedNote) { note in
                PagingFullscreenView(notes: notes, selectedNote: $vm.selectedNote)
            }
            
            .photosPicker(
                isPresented: $vm.activatePhotosPicker,
                selection: $vm.selectedPhotoItems,
                maxSelectionCount: 15,
                matching: .images,
                photoLibrary: .shared()
            )
            .onChange(of: vm.selectedPhotoItems) {
                Task {
                    await vm.processPhotoItems(vm.selectedPhotoItems, with: modelContext)
                    vm.selectedPhotoItems = []
                }
            }
        }
        .accessibilityLabel("Notes Wall View")
    }
}
 
let previewContainer: ModelContainer = {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Note.self, configurations: config)
    Task { @MainActor in
        // Assuming Note.samples are defined elsewhere or provide real data
        // For a minimal working example, you might need to define dummy data here
        // For instance: [Note(text: "Hello", colorID: 0)]
    }
    return container
}()

    
    #Preview {
        NotesWallView()
            .modelContainer(previewContainer)
}
