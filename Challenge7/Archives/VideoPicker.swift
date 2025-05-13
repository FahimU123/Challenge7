//
//  VideoPicker.swift
//  Challenge7
//
//  Created by Davaughn Williams on 5/5/25.
//

import SwiftUI
import UIKit
import AVKit

struct VideoPicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
//    @Binding var videoURL: URL?
    @Binding var videoPath: String?
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.mediaTypes = ["public.movie"]
        picker.videoQuality = .typeHigh
        picker.videoExportPreset = AVAssetExportPresetPassthrough
        picker.allowsEditing = false
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ UIViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: VideoPicker
        
        init(_ parent: VideoPicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
//            if let mediaURL = info[.mediaURL] as? URL {
//                parent.videoURL = mediaURL
            if let mediaURL = info[.mediaURL] as? URL, let savedURL = saveVideoToDocuments(from: mediaURL) {
//                parent.videoURL = savedURL
                parent.videoPath = savedURL.path
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        private func saveVideoToDocuments(from sourceURL: URL) -> URL? {
            let fileManager = FileManager.default
            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            let uniqueName = UUID().uuidString + ".mov"
            let destinationURL = documentsURL.appendingPathComponent(uniqueName)
            
            do {
                try fileManager.copyItem(at: sourceURL, to: destinationURL)
                print("Video saved to : \(destinationURL.path)")
                return destinationURL
            } catch {
                print("Failed to copy video to documents: \(error)")
                return nil
            }
        }
    }
}
