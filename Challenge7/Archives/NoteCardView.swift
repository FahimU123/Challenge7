//
//  NoteCardView.swift
//  C7MacroChallenge
//
//  Created by Davaughn Williams on 4/29/25.
//

import SwiftUI
import AVKit
import UIKit

struct NoteCardView: View {
    let note: Note
    @State private var play = false
    
    private var persistentColor: Color {
        let colors: [Color] = [.col, .cardColor1, .cardColor2, .cardColor3]
        return colors.indices.contains(note.colorID) ? colors[note.colorID] : .gray
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            if let photo = note.imageData,
               (note.text == nil || note.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true),
               let image = UIImage(data: photo) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 175)
                    .cornerRadius(32, corners: [.topLeft, .topRight])
            } else if let text = note.text,
                      !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                      note.imageData == nil {
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 32)
                        .fill(persistentColor)
                        .frame(width: 175)
                        .frame(minHeight: 100, maxHeight: 224)

                    Text(text)
                        .font(.system(size: 12, design: .default))
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.leading)
                        .lineLimit(13)
                        .frame(maxWidth: 155, maxHeight: 210, alignment: .leading)
                        .padding()
                }
                .fixedSize(horizontal: false, vertical: true)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 32))
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
        TabView{
//             Long Sample Note
            NoteCardView(note: Note(text: "Long Note: Lorem ipsum dolor sit amet, consectetur adipiscing elit. In iaculis turpis sed justo luctus aliquam. Mauris ac arcu vestibulum, venenatis mi finibus, porta massa. Curabitur auctor, magna vitae condimentum laoreet.", imageData: nil))
            
//             Very Long Sample Note
            NoteCardView(note: Note(text: "Long Note: Lorem ipsum dolor sit amet, consectetur adipiscing elit. In iaculis turpis sed justo luctus aliquam. Mauris ac arcu vestibulum, venenatis mi finibus, porta massa. Curabitur auctor, magna vitae condimentum laoreet shy shy shy shy shy shy shy shy  shy shy shy shy shy shy shy shy shy shy shys hsy shsy s syshs s shys  s hs.", imageData: nil))

            
//             Shorter Sample Note
            NoteCardView(note: Note(text: "Short Note: Lorem ipsum dolor sit amet, consectetur adipiscing elit.", imageData: nil))
            
//             Sample Image Note
            if let url = Bundle.main.url(forResource: "samplePhoto", withExtension: "jpeg"),
               let data = try? Data(contentsOf: url) {
                NoteCardView(note: Note(text: nil, imageData: data))
            } else {
                Text("Image not found")
            }
    }
        .tabViewStyle(.page)
}
