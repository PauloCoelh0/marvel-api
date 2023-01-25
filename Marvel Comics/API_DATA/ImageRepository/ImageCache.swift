//
//  ImageCache.swift
//  Marvel Comics
//
//  Created by Paulo Coelho on 14/01/2023.
//

import UIKit

final class ImageCache {
    private let cachedImages = NSCache<NSURL, UIImage>()

    func setImage(_ image: UIImage, url: NSURL, responseData: Data) {
        print("Saving image with url: \(url) to cache")
        cachedImages.setObject(image, forKey: url, cost: responseData.count)
    }

    func load(url: NSURL, item: CharacterRepresentableViewModel) -> UIImage? {
        print("Loading image with url: \(url) from cache")
        return cachedImages.object(forKey: url)
    }
    
    func loadE(url: NSURL, item: EventRepresentableViewModel) -> UIImage? {
        print("Loading image with url: \(url) from cache")
        return cachedImages.object(forKey: url)
    }
}
