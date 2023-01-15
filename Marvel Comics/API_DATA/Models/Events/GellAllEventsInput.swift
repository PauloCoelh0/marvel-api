//
//  GellAllEventsInput.swift
//  Marvel Comics
//
//  Created by Paulo Coelho on 15/01/2023.
//

import Foundation

enum OrderByE: String, Codable {
    case title
    case modified
    case nameDescending = "-title"
    case modifiedDescending = "-modified"
}

struct GellAllEventsInput: Codable {
    let title: String?
    let titleStartsWith: String?
    let modifiedSince: Date?
    let comics: Int?
    let orderBy: OrderByE?
    let limit: Int?
    let offset: Int?
    
    init(title: String? = nil, titleStartsWith: String? = nil, modifiedSince: Date? = nil, comics: Int? = nil, orderBy: OrderByE? = nil, limit: Int? = nil, offSet: Int? = nil) {
        self.title = title
        self.titleStartsWith = titleStartsWith
        self.modifiedSince = modifiedSince
        self.comics = comics
        self.orderBy = orderBy
        self.limit = limit
        self.offset = offSet
    }
}
