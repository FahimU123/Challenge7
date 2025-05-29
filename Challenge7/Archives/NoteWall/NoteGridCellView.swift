//
//  NoteGridCellView.swift
//  Challenge7
//
//  Created by Davaughn Williams on 5/29/25.
//

import SwiftUI

struct NoteGridCellView: View {
    let note: Note
    let isSelected: Bool
    let selectionMode: Bool
    let onTap: () -> Void
    let onLongPress: () -> Void
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            NoteCardView(
                vm: NoteCardViewModel(note: note),
                onTap: onTap,
                onLongPress: onLongPress
            )
            
            if selectionMode {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(isSelected ? .blue : .gray)
                    .font(.title2)
                    .padding(0)
            }
        }
    }
}
