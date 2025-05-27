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
    var createdAt: Date = Date()
    var colorID: Int
    
    init(text: String?, imageData: Data?) {
        self.id = UUID()
        self.text = text
        self.imageData = imageData
        self.colorID = Int.random(in: 0..<4)
    }
}
