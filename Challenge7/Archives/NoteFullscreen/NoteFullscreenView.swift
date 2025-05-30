//
//  NoteFullscreenView.swift
//  Challenge7
//
//  Created by Davaughn Williams on 5/26/25.
//


import SwiftUI

struct NoteFullscreenView: View {
    @StateObject var vm: NoteFullscreenViewModel
    
    var body: some View {
        if let selected = vm.selectedNote,
           vm.notes.contains(selected) {
            ZStack(alignment: .topTrailing) {
                TabView(selection: $vm.currentNoteID) {
                    if let currentID = vm.currentNoteID,
                       let currentIndex = vm.notes.firstIndex(where: { $0.id == currentID }) {

                        let range = max(0, currentIndex - 1)...min(vm.notes.count - 1, currentIndex + 1)

                        ForEach(vm.notes[range], id: \.self) { note in
                            Group {
                                if let imageData = note.imageData,
                                   let image = UIImage(data: imageData) {
                                    ImageNoteView(image: image)
                                } else if let text = note.text {
                                    TextNoteView(text: text, backgroundColor: vm.colorFrom(note.colorID))
                                } else {
                                    Color.black
                                }
                            }
                            .id(note.id)
                            .tag(note.id)
                            .transition(.identity)
                        }
                    }
                }
                .onAppear {
                    vm.initializeCurrentNote()
                }
                .onAppear {
                    vm.initializeCurrentNote()
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .background(Color.black.edgesIgnoringSafeArea(.all))
                .ignoresSafeArea()
                
                Button(action: {
                    vm.dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                        .padding()
                }
            }
        }
    }
}
    
#Preview {
    struct PreviewWrapper: View {
        @State private var selectedNote: Note? = Note.samples.first

        var body: some View {
            NoteFullscreenView(vm: NoteFullscreenViewModel(notes: Note.samples, selectedNote: $selectedNote))
            
        }
    }

    return PreviewWrapper()
}
