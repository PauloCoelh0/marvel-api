//
//  UIImageLoader.swift
//  Marvel Comics
//
//  Created by Paulo Coelho on 14/01/2023.
//

import UIKit

final class UIImageLoader {
    static let share = UIImageLoader()
    private let imageDataRepository = ImageDataRepository()
    private var items = [UIImageView: CharacterRepresentableViewModel]()
        
    func load(_ url: URL, item: CharacterRepresentableViewModel, for imageView: UIImageView, completion: @escaping (()-> Void)) {
        imageDataRepository.load(url: url as NSURL, item: item) { item, image in
            defer { self.items.removeValue(forKey: imageView) }
            DispatchQueue.main.async {
                self.items[imageView] = item
                imageView.image = image
                item.image = image
                completion()
            }
        }
    }
    
    func cancel(for imageView: UIImageView) {
        if let item = items[imageView] {
            imageDataRepository.cancelLoad(item)
            items.removeValue(forKey: imageView)
        }
    }
}
