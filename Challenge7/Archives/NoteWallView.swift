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
    @State private var showingNewNoteSheet = false
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ZStack {
            
            
            VStack {
                HStack {
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
                            .foregroundStyle(.black)
                            .font(.system(size: 35))
                            .fontWeight(.ultraLight)
                            .padding()
                    }
                }
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(notes) { note in
                            NoteCardView(note: note)
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
}

#Preview {
    NotesWallView()
        .modelContainer(for: Note.self)
}
