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
    
    private var loadingResponsesE = [NSURL: [(EventRepresentableViewModel, UIImage?) -> Void]]()
    private var runningRequestsE = [EventRepresentableViewModel: URLSessionDataTask]()
    
    
    
    
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
    
    
    func loadE(url: NSURL, itemE: EventRepresentableViewModel, completion: @escaping (EventRepresentableViewModel, UIImage?) -> Void) {
        if let image = imageCache.loadE(url: url, item: itemE) {
            completion(itemE, image)
            return
        }
        let task = URLSession.shared.dataTask(with: url as URL) { (data, response, error) in
            defer { self.runningRequestsE.removeValue(forKey: itemE) }
            guard
                error == nil,
                let responseData = data,
                let image = UIImage(data: responseData) else {
                completion(itemE , nil)
                return
            }
            self.imageCache.setImage(image, url: url, responseData: responseData)
            completion(itemE, image)
        }
        task.resume()
        runningRequestsE[itemE] = task
    }
    
    func cancelLoad(_ item: CharacterRepresentableViewModel) {
        runningRequests[item]?.cancel()
        runningRequests.removeValue(forKey: item)
    }
    
    func cancelLoadE(_ item: EventRepresentableViewModel) {
        runningRequestsE[item]?.cancel()
        runningRequestsE.removeValue(forKey: item)
    }
}

