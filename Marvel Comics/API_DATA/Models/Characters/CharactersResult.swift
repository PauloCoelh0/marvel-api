//
//  CharactersResult.swift
//  Marvel Comics
//
//  Created by Paulo Coelho on 14/01/2023.
//

import Foundation

struct CharactersResult: Codable {
    let id: Int?
    let name: String?
    let resultDescription: String?
    let dateModified: String?
    let thumbnail: Thumbnail?
    let resourceURI: String?
    let comics: Comics
    let series: Comics
    let stories: Stories?
    let events: Comics?
    let urls: [URLElement]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case resultDescription = "description"
        case dateModified = "modified"
        case thumbnail
        case resourceURI
        case comics
        case series
        case stories
        case events
        case urls
    }
}
