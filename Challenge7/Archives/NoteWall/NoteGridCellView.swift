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
            .accessibilityHidden(selectionMode)

            if selectionMode {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(isSelected ? .blue : .gray)
                    .font(.title2)
                    .padding(.top, 6)
                    .padding(.leading, 12)
                    .accessibilityHidden(true)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(note.text ?? "Note")
        .accessibilityValue(isSelected ? "Selected" : "Not selected")
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
        .accessibilityHint(selectionMode ?
                          (isSelected ? "Double tap to deselect this note." : "Double tap to select this note.") :
                          "Double tap to open note details. Long press for more options.")
        .onTapGesture {
            onTap()
        }
        .onLongPressGesture {
            onLongPress()
        }
    }
}
