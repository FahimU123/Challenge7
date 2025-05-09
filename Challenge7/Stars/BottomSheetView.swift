//
//  BottomSheetView.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/9/25.
//

import SwiftUI

struct BottomSheetView: View {

    var isExpanded: Bool
    var viewModel: CounterViewModel
    var note: Note?
    @State private var showFullNoteView = false
    
    var body: some View {
        VStack(spacing: 16) {
            Capsule()
                .fill(Color.gray)
                .frame(width: 40, height: 6)
                .padding(.top, 8)
            
            
            ScrollView {
                VStack(spacing: 20) {
                    StatCardView()
                        .padding(.vertical)
                    
                    Button {
                        showFullNoteView.toggle()
                    } label: {
                       RandomNoteView(note: note)
                    }
                    .fullScreenCover(isPresented: $showFullNoteView, content: NotesWallView.init)
                            
                        }
                        .padding(.top)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.ultraThinMaterial)
                .cornerRadius(isExpanded ? 0 : 16)
            }
        }
#Preview {
    BottomSheetView(isExpanded: true, viewModel: CounterViewModel())
}
