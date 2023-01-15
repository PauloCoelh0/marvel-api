//
//  EventListConfiguration.swift
//  Marvel Comics
//
//  Created by Paulo Coelho on 15/01/2023.
//

import Foundation

struct EventListConfiguration {
    
    static let repository: DataRepositoryProtocol = DataRepository(dataSource: NetworkingDataSource())
    
    
}
