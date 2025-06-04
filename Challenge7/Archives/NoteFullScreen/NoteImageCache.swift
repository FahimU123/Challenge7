//
//  NoteImageCache.swift
//  Challenge7
//
//  Created by Davaughn Williams on 5/30/25.
//


import SwiftUI

final class NoteImageCache: ObservableObject {
    @Published var images: [UUID: UIImage] = [:]

    func image(for note: Note) -> UIImage? {
        if let cached = images[note.id] {
            return cached
        } else if let data = note.imageData, let image = downscaledImage(from: data) {
            images[note.id] = image
            return image
        }
        return nil
    }

    func preload(notes: [Note], around index: Int) {
        let range = max(0, index - 3)...min(notes.count - 1, index + 3)
        for i in range {
            let note = notes[i]
            if images[note.id] == nil,
               let data = note.imageData,
               let image = UIImage(data: data) {
                images[note.id] = image
            }
        }
    }
    
    func downscaledImage(from data: Data, maxDimension: CGFloat = 1000) -> UIImage? {
        let options: [CFString: Any] = [
            kCGImageSourceShouldCache: false
        ]
        guard let source = CGImageSourceCreateWithData(data as CFData, options as CFDictionary),
              let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [CFString: Any],
              let _ = properties[kCGImagePropertyPixelWidth] as? CGFloat,
              let _ = properties[kCGImagePropertyPixelHeight] as? CGFloat else { return nil }

        let downsampleOptions: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimension,
            kCGImageSourceCreateThumbnailWithTransform: true
        ]

        guard let cgImage = CGImageSourceCreateThumbnailAtIndex(source, 0, downsampleOptions as CFDictionary) else { return nil }
        return UIImage(cgImage: cgImage)
    }
}
