//
//  ImageView.swift
//  SwiftUITraining
//
//  Created by f-rm on 2021/08/23.
//

import SwiftUI

struct ImageView: View {
    
    @ObservedObject private var imageloader: ImageLoader
    
    private let placeholder: Image?
    
    init(url: URL, placeholder: Image? = nil) {
        imageloader = ImageLoader(url: url)
        self.placeholder = placeholder
    }
    
    init(urlStr: String, placeholder: Image? = nil) {
        imageloader = ImageLoader(urlStr: urlStr)
        self.placeholder = placeholder
    }
    
    var body: some View {
        Group {
            if let image = imageloader.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                placeholder
            }
        }
        .onAppear(perform: imageloader.load)
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(urlStr: "")
    }
}
