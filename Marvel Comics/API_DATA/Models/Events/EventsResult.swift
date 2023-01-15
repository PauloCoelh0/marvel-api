//
//  EventsResult.swift
//  Marvel Comics
//
//  Created by Paulo Coelho on 15/01/2023.
//

import Foundation

struct EventsResult: Codable {
    let id: Int?
    let title: String?
    let resultDescription: String?
    let dateModified: String?
    let thumbnail: Thumbnail?
    let resourceURI: String?
    let comics: Comics
    let series: Comics
    let stories: Stories?
    let characters: Comics?
    let urls: [URLElement]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case resultDescription = "description"
        case dateModified = "modified"
        case thumbnail
        case resourceURI
        case comics
        case series
        case stories
        case characters
        case urls
    }
}
