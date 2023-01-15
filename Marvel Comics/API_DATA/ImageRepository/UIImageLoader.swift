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
    private var itemsE = [UIImageView: EventRepresentableViewModel]()
        
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
    
    func loadE(_ url: URL, itemE: EventRepresentableViewModel, for imageViewE: UIImageView, completion: @escaping (()-> Void)) {
        imageDataRepository.loadE(url: url as NSURL, itemE: itemE) { itemE, image in
            defer { self.itemsE.removeValue(forKey: imageViewE) }
            DispatchQueue.main.async {
                self.itemsE[imageViewE] = itemE
                imageViewE.image = image
                itemE.image = image
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
