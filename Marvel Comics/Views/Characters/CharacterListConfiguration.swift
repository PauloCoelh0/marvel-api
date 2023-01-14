//
//  CharacterListConfiguration.swift
//  Marvel Comics
//
//  Created by Paulo Coelho on 14/01/2023.
//

import Foundation

struct CharacterListConfiguration {
    
    static let repository: DataRepositoryProtocol = DataRepository(dataSource: NetworkingDataSource())
    
    
}
