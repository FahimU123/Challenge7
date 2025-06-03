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
                    
                    Text("Why I'm Doing This")
                        .font(
                            .system(size: 24, weight: .medium, design: .default)
                        )
                        .padding(.leading)
                        .popoverTip(tip)
                    
                    Spacer()
                    
                    Menu {
                        Button {
                            vm.activatePhotosPicker = true
                        } label: {
                            Label("Add Photo", systemImage: "photo")
                        }
                        
                        Button {
                            vm.showingNewNoteSheet = true
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
                
                if vm.selectionMode {
                    Text("Tap notes to select. Tap trash to delete.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 4)
                }
                
                ScrollView {
                    LazyVStack {
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
                    }
                    .gridStyle(columnsInPortrait: 2, columnsInLandscape: 3, spacing: 8)
                    .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                    }
                }
                
                HStack {
                    if vm.selectionMode {
                        Button {
                            vm.selectionMode = false
                            vm.selectedNotes.removeAll()
                        } label: {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(Color.green)
                                .font(.system(size: 35))
                        }
                        
                        if !vm.selectedNotes.isEmpty {
                            Button(role: .destructive) {
                                vm.showDeleteConfirmation = true
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundStyle(Color.red)
                                    .font(.system(size: 24))
                            }
                            .confirmationDialog(
                                "Are you sure you want to delete the selected notes?",
                                isPresented: $vm.showDeleteConfirmation,
                                titleVisibility: .visible
                            ) {
                                Button("Delete", role: .destructive) {
                                    vm.deleteSelectedNotes(using: modelContext)
                                }
                                Button("Cancel" ,role: .cancel) { }
                            }
                            
                            .padding(.trailing)
                        }
                    }
                }
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
                }
            }
        }
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
