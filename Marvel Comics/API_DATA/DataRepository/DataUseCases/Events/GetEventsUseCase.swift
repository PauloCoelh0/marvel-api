//
//  GetEventsUseCase.swift
//  Marvel Comics
//
//  Created by Paulo Coelho on 15/01/2023.
//

import Foundation

final class GetEventsUseCase {
    private let dataRepository: DataRepositoryProtocol
    
    init(repository: DataRepositoryProtocol) {
        dataRepository = repository
    }
    
    func execute(offset: Int) throws -> EventsViewModel {
        return try dataRepository.getAllEvents(offset: offset)
    }
}
