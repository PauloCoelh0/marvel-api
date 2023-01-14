//
//  Comics.swift
//  Marvel Comics
//
//  Created by Paulo Coelho on 14/01/2023.
//

import Foundation

struct Comics: Codable {
    let available: Int?
    let collectionURI: String?
    let returned: Int?
    let items: [ComicsItem]?
}

