//
//  DataRepository.swift
//  Marvel Comics
//
//  Created by Paulo Coelho on 14/01/2023.
//

import Foundation

protocol DataRepositoryProtocol {
    func getAllCharacters(offset: Int) throws -> CharactersViewModel
    func getCharacter(_ input: GellAllCharactersInput) throws -> CharactersViewModel
}

final class DataRepository: DataRepositoryProtocol {
    private let dataSource: DataSourceProtocol
    
    init(dataSource: DataSourceProtocol) {
        self.dataSource = dataSource
    }

    func getAllCharacters(offset: Int) throws -> CharactersViewModel {
        let response = try dataSource
            .getAllCharacters(inputParam: GellAllCharactersInput(offSet: offset ))
        return CharactersViewModel(response)
    }
    
    func getCharacter(_ input: GellAllCharactersInput) throws -> CharactersViewModel {
        let response = try dataSource
            .getAllCharacters(inputParam: input)
        return CharactersViewModel(response)
    }

}

