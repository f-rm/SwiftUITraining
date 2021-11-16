//
//  ImageStore.swift
//  SwiftUITraining
//
//  Created by f-rm on 2021/08/23.
//

import UIKit

class ImageStore: ObservableObject {
    
    @Published var image: UIImage = UIImage(named: "noimage")!

    init(from resource: URL) {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: resource) { [weak self] data, _, _ in
            guard let imageData = data,
                  let networkImage = UIImage(data: imageData) else {
                return
            }
            DispatchQueue.main.async {
                self?.image = networkImage
            }
            session.invalidateAndCancel()
        }
        task.resume()
    }
}
