//
//  TextNoteView.swift
//  Challenge7
//
//  Created by Davaughn Williams on 5/29/25.
//

import SwiftUI

struct TextNoteView: View {
    let text: String
    let backgroundColor: Color
    
    
    var body: some View {
        ZStack {
            backgroundColor
                .edgesIgnoringSafeArea(.all)
            GeometryReader { geometry in
                ZStack {
                    if textHeight(for: text, in: geometry.size.width) > geometry.size.height {
                        ScrollView {
                            Text(text)
                                .font(.title)
                                .padding()
                                .foregroundStyle(.white)
                        }
                    } else {
                        VStack {
                            Spacer()
                            Text(text)
                                .font(.title)
                                .padding()
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .lineLimit(nil)
                                .truncationMode(.tail)
                            Spacer()
                        }
                    }
                }
            }
        }
    }
    
    private func textHeight(for text: String, in width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width - 32, height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [.font: UIFont.preferredFont(forTextStyle: .title1)],
            context: nil
        )
        return ceil(boundingBox.height)
    }
}
