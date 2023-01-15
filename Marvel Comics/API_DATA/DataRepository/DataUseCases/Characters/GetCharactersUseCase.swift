//
//  GetCharactersUseCase.swift
//  Marvel Comics
//
//  Created by Paulo Coelho on 14/01/2023.
//

import Foundation

final class GetCharactersUseCase {
    private let dataRepository: DataRepositoryProtocol
    
    init(repository: DataRepositoryProtocol) {
        dataRepository = repository
    }
    
    func execute(offset: Int) throws -> CharactersViewModel {
        return try dataRepository.getAllCharacters(offset: offset)
    }
}
