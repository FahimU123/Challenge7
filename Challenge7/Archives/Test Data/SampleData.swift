//
//  SampleData.swift
//  Challenge7
//
//  Created by Davaughn Williams on 5/5/25.
//

import Foundation
import UIKit

extension UIImage {
    static func solidColor(_ color: UIColor, size: CGSize = CGSize(width: 100, height: 100)) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            context.fill(CGRect(origin: .zero, size: size))
        }
    }
}

private let samplePhoto: Data? = {
    if let path = Bundle.main.path(forResource: "samplePhoto", ofType: "jpeg"),
       let image = UIImage(contentsOfFile: path) {
        return image.jpegData(compressionQuality: 1.0)
    }
    return nil
}()

extension Note {
    static var sample: Note {
        Note(
            text: "Test note with image",
            imageData: UIImage.solidColor(.blue).jpegData(compressionQuality: 1.0),
        )
    }
    
    static var samples: [Note] {
        [
            Note(text: "Only Note", imageData: nil),
            Note(text: nil, imageData: samplePhoto)
        ]
    }
}
