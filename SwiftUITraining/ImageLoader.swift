//
//  ImageLoader.swift
//  SwiftUITraining
//
//  Created by f-rm on 2021/08/23.
//

import SwiftUI

class ImageLoader: ObservableObject {
    
    @Published var image: UIImage? = UIImage(named: "noimage")
    
    private let url: URL
    
    private(set) var isLoading = false
    
    init(url: URL) {
        self.url = url
    }
    
    init(urlStr: String) {
        self.url = URL(string: urlStr)!
    }
    
    private func fetchImage() {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { [weak self] data, response, error in
            guard let imagedata = data,
                  let networkImage = UIImage(data: imagedata) else {
                return
            }
            
            DispatchQueue.main.async {
                self?.image = networkImage
            }
            session.invalidateAndCancel()
        }
        task.resume()
    }
    
    func load() {
        fetchImage()
    }
}
