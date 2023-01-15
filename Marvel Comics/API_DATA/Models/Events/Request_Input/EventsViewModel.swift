//
//  EventsViewModel.swift
//  Marvel Comics
//
//  Created by Paulo Coelho on 15/01/2023.
//

import Foundation

struct EventsViewModel {
    let offset: Int
    let limit: Int
    let total: Int
    let count: Int
    let events: [EventViewModel]
    
    init(_ dto: Events) {
        offset = dto.data?.offset ?? -1
        limit = dto.data?.offset ?? -1
        total = dto.data?.total ?? -1
        count = dto.data?.count ?? -1
        events = dto.data?.results?
            .map { EventViewModel($0) } ?? []
    }
}

struct EventViewModel {
    let eventID: Int
    let title: String
    let description: String?
    let thumbnail: ThumbnailViewModelE?
    let resourceURI: String?
    let comics: ItemViewModelE
    let series: ItemViewModelE
    let characters: ItemViewModelE
    let urls: [URLTypeViewModelE]
    
    init(_ dto: EventsResult) {
        eventID = dto.id ?? UUID().hashValue
        title = dto.title ?? ""
        description = dto.resultDescription
        thumbnail = ThumbnailViewModelE(dto.thumbnail)
        resourceURI = dto.resourceURI
        comics = ItemViewModelE(dto.comics)
        series = ItemViewModelE(dto.series)
        characters = ItemViewModelE(dto.characters)
        urls = dto.urls?.map { URLTypeViewModelE($0) } ?? []
    }
}

struct ItemViewModelE {
    let available: Int?
    let collectionURI: String?
    let items: [ItemDetailViewModelE]
    
    init(_ dto: Comics?) {
        available = dto?.available
        collectionURI = dto?.collectionURI
        items = dto?.items?.map { ItemDetailViewModelE($0) } ?? []
    }
}

struct ItemDetailViewModelE {
    let resourceURI: String?
    let name: String?
    let type: String?
    
    init(_ dto: ComicsItem?) {
        resourceURI = dto?.resourceURI
        name = dto?.name
        type = nil
    }
}

struct ThumbnailViewModelE {
    let path: String
    let thumbnailExtension: String
    
    init(_ dto: Thumbnail?) {
        path = dto?.path ?? ""
        thumbnailExtension = dto?.thumbnailExtension ?? ""
    }
    
    var imageURL: String {
        return path + "." + thumbnailExtension
    }
}

struct StoriesItemViewModelE {
    let resourceURI: String?
    let name: String?
    let type: String?
}

enum URLTypeE: String, Codable {
    case comiclink = "comiclink"
    case detail = "detail"
    case wiki = "wiki"
}

struct URLTypeViewModelE {
    let type: URLType?
    let url: String?
    
    init(_ dto: URLElement?) {
        type = URLType(rawValue: dto?.type ?? "")
        url = dto?.url ?? ""
    }
}
