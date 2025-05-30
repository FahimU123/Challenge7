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
        GeometryReader { geometry in
            ZStack {
                backgroundColor
                    .edgesIgnoringSafeArea(.all)

                Group {
                    let fitsScreen = textHeight(for: text, in: geometry.size.width) < geometry.size.height * 0.85

                    if fitsScreen {
                        VStack {
                            Spacer()
                            Text(text)
                                .font(.title)
                                .padding()
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                            Spacer()
                        }
                    } else {
                        ScrollView(showsIndicators: false) {
                            VStack(alignment: .center) {
                                Text(text)
                                    .font(.title)
                                    .padding(.top, 60)
                                    .padding(.horizontal)
                                    .foregroundStyle(.white)
                                    .multilineTextAlignment(.center)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .frame(maxWidth: .infinity)
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
