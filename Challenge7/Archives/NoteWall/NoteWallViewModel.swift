//
//  NoteWallViewModel.swift
//  Challenge7
//
//  Created by Davaughn Williams on 5/28/25.
//

import SwiftUI
import SwiftData
import PhotosUI

@MainActor
class NoteWallViewModel: ObservableObject {
    @Published var showingNewNoteSheet = false
    @Published var selectionMode = false
    @Published var selectedNotes: Set<Note> = []
    @Published var selectedPhotoItems: [PhotosPickerItem] = []
    @Published var activatePhotosPicker = false
    @Published var selectedNote: Note? = nil
    @Published var showDeleteConfirmation = false
    @Published var showFullscreen = false
    @Published var selectedNoteIndex: Int = 0

    func toggleSelection(for note: Note) {
        if selectedNotes.contains(note) {
            selectedNotes.remove(note)
        } else {
            selectedNotes.insert(note)
        }
    }

    func deleteSelectedNotes(using modelContext: ModelContext) {
        for note in selectedNotes {
            modelContext.delete(note)
        }
        try? modelContext.save()
        selectedNotes.removeAll()
        selectionMode = false
    }

    func processPhotoItems(_ items: [PhotosPickerItem], with modelContext: ModelContext) async {
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
                print("Failed to process picker item: \(error)")
            }
        }

        try? modelContext.save()
    }
}

//import SwiftUI
//import PhotosUI
//import SwiftData
//
//class NoteWallViewModel: ObservableObject {
//    @Published var showingNewNoteSheet = false
//    @Published var selectionMode = false
//    @Published var selectedNotes: Set<Note> = []
//    @Published var selectedPhotoItems: [PhotosPickerItem] = []
//    @Published var activatePhotosPicker = false
//    @Published var showFullscreen = false
//    @Published var selectedNoteIndex: Int = 0
//    @Published var selectedNote: Note? = nil
//
//    var notes: [Note] = []
//    var modelContext: ModelContext?
//
//    func bindModelContext(_ context: ModelContext) {
//        self.modelContext = context
//    }
//
//    func toggleSelection(for note: Note) {
//        if selectedNotes.contains(note) {
//            selectedNotes.remove(note)
//        } else {
//            selectedNotes.insert(note)
//        }
//    }
//
//    func isSelected(_ note: Note) -> Bool {
//        selectedNotes.contains(note)
//    }
//
//    func clearSelections() {
//        selectedNotes.removeAll()
//    }
//
//    func randomNote() -> Note? {
//        notes.randomElement()
//    }
//
//    func deleteSelectedNotes() {
//        guard let context = modelContext else { return }
//        for note in selectedNotes {
//            context.delete(note)
//        }
//        selectedNotes.removeAll()
//        selectionMode = false
//    }
//
//    func processPhotoItems() async {
//        guard let context = modelContext else { return }
//
//        for item in selectedPhotoItems {
//            if let data = try? await item.loadTransferable(type: Data.self),
//               let image = UIImage(data: data),
//               let imageData = image.jpegData(compressionQuality: 0.8) {
//                let newNote = Note(text: nil, imageData: imageData)
//                context.insert(newNote)
//            }
//        }
//
//        selectedPhotoItems = []
//        activatePhotosPicker = false
//    }
//}
