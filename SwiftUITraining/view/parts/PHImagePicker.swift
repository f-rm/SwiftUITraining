//
//  PHImagePickerView.swift
//  SwiftUITraining
//
//  Created by f-rm on 2022/03/03.
//

import SwiftUI
import PhotosUI

struct PHImagePicker: UIViewControllerRepresentable {
    
    @Binding var image: UIImage?
    @Binding var picker: Bool
    
    func makeCoordinator() -> Coordinator {
        return PHImagePicker.Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> some UIViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    class Coordinator: NSObject,PHPickerViewControllerDelegate {
        var parent: PHImagePicker
        
        init(parent: PHImagePicker) {
            self.parent = parent
        }
        
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            
            parent.picker.toggle()
            
            for result in results {
                if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    result.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                        if let image = image as? UIImage {
                            // 選択された画像を追加する
                            self.parent.image = image
                        } else {
                            print("could not get image", error)
                        }
                    }
                } else {
                    print("could not get image")
                }
            }
        }
    }
}
