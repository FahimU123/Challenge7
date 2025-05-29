//
//  NoteCardViewModel.swift
//  Challenge7
//
//  Created by Davaughn Williams on 5/29/25.
//


import SwiftUI

class NoteCardViewModel: ObservableObject {
    let note: Note

    init(note: Note) {
        self.note = note
    }

    var image: UIImage? {
        guard let data = note.imageData else { return nil }
        return UIImage(data: data)
    }

    var backgroundColor: Color {
        let colors: [Color] = [.col, .cardColor1, .cardColor2, .cardColor3]
        return colors.indices.contains(note.colorID) ? colors[note.colorID] : .gray
    }
}

