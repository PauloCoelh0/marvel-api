//
//  Extension+UIImageView.swift
//  Marvel Comics
//
//  Created by Paulo Coelho on 14/01/2023.
//

import UIKit

extension UIImageView {
    func loadImage(at url: URL, for item: CharacterRepresentableViewModel, completion: @escaping () -> Void) {
        UIImageLoader.share.load(url, item: item, for: self, completion: completion)
    }
    
    func loadImageE(at url: URL, for itemE: EventRepresentableViewModel, completion: @escaping () -> Void) {
        UIImageLoader.share.loadE(url, itemE: itemE, for: self, completion: completion)
    }
    
    func cancelImageLoad() {
        UIImageLoader.share.cancel(for: self)
    }
}
