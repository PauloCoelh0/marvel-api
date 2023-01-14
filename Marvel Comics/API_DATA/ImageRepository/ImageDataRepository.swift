//
//  ImageDataRepository.swift
//  Marvel Comics
//
//  Created by Paulo Coelho on 14/01/2023.
//

import UIKit

final class ImageDataRepository {
    static let shared = ImageDataRepository()
    private var loadingResponses = [NSURL: [(CharacterRepresentableViewModel, UIImage?) -> Void]]()
    private var runningRequests = [CharacterRepresentableViewModel: URLSessionDataTask]()
    private var imageCache = ImageCache()
    
    func load(url: NSURL, item: CharacterRepresentableViewModel, completion: @escaping (CharacterRepresentableViewModel, UIImage?) -> Void) {
        if let image = imageCache.load(url: url, item: item) {
            completion(item, image)
            return
        }
        let task = URLSession.shared.dataTask(with: url as URL) { (data, response, error) in
            defer { self.runningRequests.removeValue(forKey: item) }
            guard
                error == nil,
                let responseData = data,
                let image = UIImage(data: responseData) else {
                completion(item , nil)
                return
            }
            self.imageCache.setImage(image, url: url, responseData: responseData)
            completion(item, image)
        }
        task.resume()
        runningRequests[item] = task
    }
    
    func cancelLoad(_ item: CharacterRepresentableViewModel) {
        runningRequests[item]?.cancel()
        runningRequests.removeValue(forKey: item)
    }
}

