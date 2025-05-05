//
//  VideoPicker.swift
//  Challenge7
//
//  Created by Fahim Uddin on 5/5/25.
//

import SwiftUI
import UIKit
import AVKit

struct VideoPicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var videoURL: URL?
    
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
            if let mediaURL = info[.mediaURL] as? URL {
                parent.videoURL = mediaURL
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
