//
//  CharactersViewModel.swift
//  Marvel Comics
//
//  Created by Paulo Coelho on 14/01/2023.
//

import Foundation

struct CharactersViewModel {
    let offset: Int
    let limit: Int
    let total: Int
    let count: Int
    let characters: [CharacterViewModel]
    
    init(_ dto: Characters) {
        offset = dto.data?.offset ?? -1
        limit = dto.data?.offset ?? -1
        total = dto.data?.total ?? -1
        count = dto.data?.count ?? -1
        characters = dto.data?.results?
            .map { CharacterViewModel($0) } ?? []
    }
}

struct CharacterViewModel {
    let characterID: Int
    let name: String
    let description: String?
    let thumbnail: ThumbnailViewModel?
    let resourceURI: String?
    let comics: ItemViewModel
    let series: ItemViewModel
    let event: ItemViewModel
    let urls: [URLTypeViewModel]
    
    init(_ dto: CharactersResult) {
        characterID = dto.id ?? UUID().hashValue
        name = dto.name ?? ""
        description = dto.resultDescription
        thumbnail = ThumbnailViewModel(dto.thumbnail)
        resourceURI = dto.resourceURI
        comics = ItemViewModel(dto.comics)
        series = ItemViewModel(dto.series)
        event = ItemViewModel(dto.events)
        urls = dto.urls?.map { URLTypeViewModel($0) } ?? []
    }
}

struct ItemViewModel {
    let available: Int?
    let collectionURI: String?
    let items: [ItemDetailViewModel]
    
    init(_ dto: Comics?) {
        available = dto?.available
        collectionURI = dto?.collectionURI
        items = dto?.items?.map { ItemDetailViewModel($0) } ?? []
    }
}

struct ItemDetailViewModel {
    let resourceURI: String?
    let name: String?
    let type: String?
    
    init(_ dto: ComicsItem?) {
        resourceURI = dto?.resourceURI
        name = dto?.name
        type = nil
    }
}

struct ThumbnailViewModel {
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

struct StoriesItemViewModel {
    let resourceURI: String?
    let name: String?
    let type: String?
}

enum URLType: String, Codable {
    case comiclink = "comiclink"
    case detail = "detail"
    case wiki = "wiki"
}

struct URLTypeViewModel {
    let type: URLType?
    let url: String?
    
    init(_ dto: URLElement?) {
        type = URLType(rawValue: dto?.type ?? "")
        url = dto?.url ?? ""
    }
}
