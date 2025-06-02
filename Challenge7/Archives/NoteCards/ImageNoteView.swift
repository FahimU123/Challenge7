//
//  ImageNoteView.swift
//  Challenge7
//
//  Created by Davaughn Williams on 5/29/25.
//

import SwiftUI

struct ImageNoteView: View {
    let image: UIImage
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .background(Color.black)
            .drawingGroup()
    }
}
