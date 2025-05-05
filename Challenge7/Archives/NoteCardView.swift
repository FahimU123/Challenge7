//
//  NoteCardView.swift
//  C7MacroChallenge
//
//  Created by Davaughn Williams on 4/29/25.
//

import SwiftUI

struct NoteCardView: View {
    let note: Note
    
    var body: some View {
        VStack(alignment: .leading, spacing: -20) {
            
            // Image or video
            
            if let photo = note.imageData, let image = UIImage(data: photo) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 175, height: 224)
                    .clipped()
                    .cornerRadius(16, corners: [.topLeft, .topRight])
            } else if note.videoURL != nil {
                ZStack {
                    Rectangle()
                        .fill(Color.black)
                        .frame(width: 175, height: 224)
                        .cornerRadius(25, corners: [.topLeft, .topRight])
                    
                    Image(systemName: "play.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundStyle(.white)
                }
            }
            
            if let text = note.text, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color(.systemGray5))
                        .frame(width: 175)
                        .frame(minHeight: 100, maxHeight: 224)

                    Text(text)
                        .font(.system(size: 12, design: .monospaced))
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
    VStack {
//        NoteCardView(note: Note(text: "I want to make my family proud dkdkdkdkdkdkdkdkdkdkdkdkdkdkdkdkdkdkdkdkdkdkdkdkdkdkdkdkdkdkdkdkdkdkdkdkdkdkdkdkdkdkdkddkdkdkdkkddkdkdkkdkdkdkdkdkdkd", imageData: nil, videoURL: nil))
        
        let sampleImage = UIImage(named: "samplePhoto")!
        let imageData = sampleImage.jpegData(compressionQuality: 1.0)
        return NoteCardView(note: Note(text: "Note with image", imageData: imageData, videoURL: nil))
        
//        NoteCardView(note: Note(text: "With video", imageData: nil, videoURL: URL(string: "sampleVideo")))

    }
}
