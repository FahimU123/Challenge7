
import SwiftUI

@MainActor
class NoteFullscreenViewModel: ObservableObject {
    let notes: [Note]
    @Binding var selectedNote: Note?
    @Published var currentNoteID: UUID?

    init(notes: [Note], selectedNote: Binding<Note?>) {
        self.notes = notes
        self._selectedNote = selectedNote
        self.currentNoteID = selectedNote.wrappedValue?.id
    }

    func colorFrom(_ id: Int) -> Color {
        let colors: [Color] = [.col, .cardColor1, .cardColor2, .cardColor3]
        return colors.indices.contains(id) ? colors[id] : .gray
    }

    func textHeight(for text: String, in width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width - 32, height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [.font: UIFont.preferredFont(forTextStyle: .title1)],
            context: nil
        )
        return ceil(boundingBox.height)
    }

    func initializeCurrentNote() {
        if let selected = selectedNote {
            currentNoteID = selected.id
        }
    }

    func dismiss() {
        if let id = currentNoteID {
            selectedNote = notes.first(where: { $0.id == id })
        }
        selectedNote = nil
    }
}
