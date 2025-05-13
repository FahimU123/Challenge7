//
//  NoteData.swift
//  Challenge7
//
//  Created by Davaughn Williams on 5/5/25.
//

import Foundation
import SwiftData

@Model
class Note: Identifiable {
    var id: UUID
    var text: String?
    var imageData: Data?
    var videoPath: String?
    
    init(text: String?, imageData: Data?, videoPath: String?) {
        self.id = UUID()
        self.text = text
        self.imageData = imageData
        self.videoPath = videoPath
    }
}
