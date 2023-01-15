//
//  SearchEventUseCase.swift
//  Marvel Comics
//
//  Created by Paulo Coelho on 15/01/2023.
//

import Foundation

final class SearchEventUseCase {
    private let dataRepository: DataRepositoryProtocol
    
    init(repository: DataRepositoryProtocol) {
        dataRepository = repository
    }
    
    func execute(input: GellAllEventsInput) throws -> EventsViewModel {
        let title = input.title?.isEmpty ?? true ? nil : input.title
        let titleStartsWith = input.titleStartsWith?.isEmpty ?? true ? nil : input.titleStartsWith
        return try dataRepository.getEvent(GellAllEventsInput(title: title,
                                                                      titleStartsWith: titleStartsWith,
                                                                      comics: input.comics))
    }
}
