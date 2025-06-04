//
//  PagingFullscreenView.swift
//  Challenge7
//
//  Created by Davaughn Williams on 5/30/25.
//


import SwiftUI

struct PagingFullscreenView: View {
    @StateObject private var imageCache = NoteImageCache()
    let notes: [Note]
    @Binding var selectedNote: Note?

    @State private var currentIndex: Int = 0
    @GestureState private var dragOffset: CGFloat = 0

    init(notes: [Note], selectedNote: Binding<Note?>) {
            self.notes = notes
            self._selectedNote = selectedNote

            if let selected = selectedNote.wrappedValue,
               let index = notes.firstIndex(of: selected) {
                _currentIndex = State(initialValue: index)
            } else {
                _currentIndex = State(initialValue: 0)
            }
        }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            GeometryReader { geometry in
                let width = geometry.size.width
                let offset = -CGFloat(currentIndex) * width + dragOffset

                HStack(spacing: 0) {
                    ForEach(notes.indices, id: \.self) { index in
                        let note = notes[index]
                        Group {
                            if let imageData = note.imageData,
                               let image = UIImage(data: imageData) {
                                ImageNoteView(image: image)
                            } else if let text = note.text {
                                TextNoteView(text: text, backgroundColor: colorFrom(note.colorID))
                            } else {
                                Color.black
                            }
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                }
                .offset(x: offset)
                .animation(.interactiveSpring(), value: currentIndex)
                .gesture(
                    DragGesture()
                        .updating($dragOffset) { value, state, _ in
                            state = value.translation.width
                        }
                        .onEnded { value in
                            let threshold = geometry.size.width / 2
                            let predictedEnd = value.predictedEndTranslation.width
                            let drag = value.translation.width

                            if drag < -threshold || predictedEnd < -threshold {
                                currentIndex = min(currentIndex + 1, notes.count - 1)
                            } else if drag > threshold || predictedEnd > threshold {
                                currentIndex = max(currentIndex - 1, 0)
                            }
                        }
                )
            }
            .onAppear {
                updateIndexFromSelectedNote()
            }
            
            Button(action: {
                selectedNote = nil
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
                    .padding()
            }
            .padding(.top, UIApplication.shared.connectedScenes
                .compactMap { ($0 as? UIWindowScene)?.windows.first?.safeAreaInsets.top }
                .first ?? 44)
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    private func updateIndexFromSelectedNote() {
        if let selected = selectedNote, let index = notes.firstIndex(of: selected) {
            currentIndex = index
        }
    }
    
    @ViewBuilder
    private func noteView(for note: Note) -> some View {
        if let image = imageCache.image(for: note) {
            ImageNoteView(image: image)
        } else if let text = note.text {
            TextNoteView(text: text, backgroundColor: colorFrom(note.colorID))
        } else {
            Color.black
        }
    }

    private func colorFrom(_ id: Int) -> Color {
        let colors: [Color] = [.col, .cardColor1, .cardColor2, .cardColor3]
        return colors.indices.contains(id) ? colors[id] : .gray
    }
}
