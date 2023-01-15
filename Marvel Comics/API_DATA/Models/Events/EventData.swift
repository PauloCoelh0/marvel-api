//
//  EventData.swift
//  Marvel Comics
//
//  Created by Paulo Coelho on 15/01/2023.
//

import Foundation

struct EventData: Codable {
    var offset: Int?
    var limit: Int?
    var total: Int?
    var count: Int?
    let results: [EventsResult]?
}
