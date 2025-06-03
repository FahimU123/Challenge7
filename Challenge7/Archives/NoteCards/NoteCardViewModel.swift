//
//  NoteCardViewModel.swift
//  Challenge7
//
//  Created by Davaughn Williams on 5/29/25.
//


import SwiftUI

@MainActor
final class NoteCardViewModel: ObservableObject, Equatable {
    static func == (lhs: NoteCardViewModel, rhs: NoteCardViewModel) -> Bool {
        lhs.note.id == rhs.note.id &&
        lhs.note.imageData == rhs.note.imageData &&
        lhs.note.text == rhs.note.text &&
        lhs.note.colorID == rhs.note.colorID
    }

    let note: Note
    @Published var image: UIImage?

    init(note: Note) {
        self.note = note
        if let data = note.imageData {
            self.image = Self.decodeThumbnail(from: data)
        } else {
            self.image = nil
        }
    }

    var backgroundColor: Color {
        let colors: [Color] = [.col, .cardColor1, .cardColor2, .cardColor3]
        return colors.indices.contains(note.colorID) ? colors[note.colorID] : .gray
    }

    private static func decodeThumbnail(from data: Data, maxSize: CGFloat = 200) -> UIImage? {
        guard let image = UIImage(data: data) else { return nil }

        let aspectRatio = image.size.width / image.size.height
        let newSize: CGSize
        if aspectRatio > 1 {
            newSize = CGSize(width: maxSize, height: maxSize / aspectRatio)
        } else {
            newSize = CGSize(width: maxSize * aspectRatio, height: maxSize)
        }

        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resizedImage
    }
}
