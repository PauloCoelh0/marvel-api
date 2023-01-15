//
//  EventViewModel.swift
//  Marvel Comics
//
//  Created by Paulo Coelho on 15/01/2023.
//

import Foundation
import UIKit

enum EventsSection: Hashable {
    case main
}

class EventRepresentableViewModel: Hashable {
    let eventID: Int
    let title: String
    let description: String?
    var image: UIImage?
    let url: NSURL?
    let comics: [String]
    let series: [String]
    let characters: [String]
    var isFavourite: Bool = false
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(eventID)
        hasher.combine(title)
    }
    
    static func == (lsh: EventRepresentableViewModel, rhs: EventRepresentableViewModel) -> Bool {
        return
            lsh.eventID == rhs.eventID &&
            lsh.title == rhs.title
    }
    
    init(eventID: Int, title: String, description: String, url: String, comics: [String], series: [String], characters: [String]) {
        self.eventID = eventID
        self.title = title
        self.description = description.isEmpty ? "This event doesn't have any description at this moment" : description
        self.url = NSURL(string: url)
        self.comics = comics
        self.series = series
        self.characters = characters
    }
}
