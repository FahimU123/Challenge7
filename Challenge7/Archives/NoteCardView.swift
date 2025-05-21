//
//  NoteCardView.swift
//  C7MacroChallenge
//
//  Created by Davaughn Williams on 4/29/25.
//

import SwiftUI
import AVKit

struct NoteCardView: View {
    let note: Note
    
    private var persistentColor: Color {
        let colors: [Color] = [.col, .cardColor1, .cardColor2, .cardColor3]
        return colors.indices.contains(note.colorID) ? colors[note.colorID] : .gray
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            // Image or video
            
            if let photo = note.imageData, let image = UIImage(data: photo) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 175, height: 224)
                    .clipped()
                    .cornerRadius(16, corners: [.topLeft, .topRight])
            } else if let path = note.videoPath {
                let url = URL(fileURLWithPath: path)
                VideoPlayer(player: AVPlayer(url: url))
                        .frame(width: 175, height: 224)
                        .cornerRadius(25, corners: [.topLeft, .topRight])
            }
            
            if let text = note.text, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(persistentColor)
                        .frame(width: 175)
                        .frame(minHeight: 100, maxHeight: 224)

                    Text(text)
                        .font(.system(size: 12, design: .default))
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
//                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: 155, maxHeight: 210, alignment: .leading)
                        .padding()
                }
                .fixedSize(horizontal: false, vertical: true)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 25))
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
        ScrollView{
//             Long Sample Note
            NoteCardView(note: Note(text: "Long Note: Lorem ipsum dolor sit amet, consectetur adipiscing elit. In iaculis turpis sed justo luctus aliquam. Mauris ac arcu vestibulum, venenatis mi finibus, porta massa. Curabitur auctor, magna vitae condimentum laoreet.", imageData: nil, videoPath: nil))
            
//             Shorter Sample Note
            NoteCardView(note: Note(text: "Short Note: Lorem ipsum dolor sit amet, consectetur adipiscing elit.", imageData: nil, videoPath: nil))
            
//             Sample Image Note
            if let url = Bundle.main.url(forResource: "samplePhoto", withExtension: "jpeg"),
               let data = try? Data(contentsOf: url) {
                NoteCardView(note: Note(text: nil, imageData: data, videoPath: nil))
            } else {
                Text("Image not found")
            }
            
//             Sample Image Note w/ Note
            if let url = Bundle.main.url(forResource: "samplePhoto", withExtension: "jpeg"),
               let data = try? Data(contentsOf: url) {
                NoteCardView(note: Note(text: "Sample photo with text", imageData: data, videoPath: nil))
            } else {
                Text("Image not found")
            }
            
            
//             Sample Video Note
            NoteCardView(note: Note(text: nil, imageData: nil, videoPath: Bundle.main.path(forResource: "sampleVideo", ofType: "mp4")))
            
//             Sample Video w/ Note
            NoteCardView(note: Note(text: "Sample video with text", imageData: nil, videoPath: Bundle.main.path(forResource: "sampleVideo", ofType: "mp4")))
    }
}
