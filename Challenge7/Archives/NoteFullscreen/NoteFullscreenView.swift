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
                    ForEach(vm.notes, id: \.self) { note in
                        Group {
                            if let imageData = note.imageData,
                               let image = UIImage(data: imageData) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .tag(note.id)
                            } else if let text = note.text {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 0)
                                        .fill(vm.colorFrom(note.colorID))
                                        .edgesIgnoringSafeArea(.all)
                                    GeometryReader { geometry in
                                        ZStack {
                                            if vm.textHeight(for: text, in: geometry.size.width) > geometry.size.height {
                                                ScrollView {
                                                    Text(text)
                                                        .font(.title)
                                                        .padding()
                                                        .foregroundColor(.white)
                                                }
                                            } else {
                                                VStack {
                                                    Spacer()
                                                    Text(text)
                                                        .font(.title)
                                                        .padding()
                                                        .foregroundColor(.white)
                                                        .multilineTextAlignment(.center)
                                                        .frame(maxWidth: .infinity, alignment: .center)
                                                        .lineLimit(nil)
                                                        .truncationMode(.tail)
                                                    Spacer()
                                                }
                                            }
                                        }
                                    }
                                }
                                .tag(note)
                            } else {
                                EmptyView()
                                    .tag(note)
                            }
                        }
                    }
                    
                    .onAppear {
                        vm.initializeCurrentNote()
                    }
                    
                    
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
