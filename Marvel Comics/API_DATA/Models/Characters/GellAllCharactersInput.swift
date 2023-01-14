//
//  GellAllCharactersInput.swift
//  Marvel Comics
//
//  Created by Paulo Coelho on 14/01/2023.
//

import Foundation

enum OrderBy: String, Codable {
    case name
    case modified
    case nameDescending = "-name"
    case modifiedDescending = "-modified"
}

struct GellAllCharactersInput: Codable {
    let name: String?
    let nameStartsWith: String?
    let modifiedSince: Date?
    let comics: Int?
    let orderBy: OrderBy?
    let limit: Int?
    let offset: Int?
    
    init(name: String? = nil, nameStartsWith: String? = nil, modifiedSince: Date? = nil, comics: Int? = nil, orderBy: OrderBy? = nil, limit: Int? = nil, offSet: Int? = nil) {
        self.name = name
        self.nameStartsWith = nameStartsWith
        self.modifiedSince = modifiedSince
        self.comics = comics
        self.orderBy = orderBy
        self.limit = limit
        self.offset = offSet
    }
}
