//
//  DataSourceService.swift
//  Marvel Comics
//
//  Created by Paulo Coelho on 14/01/2023.
//

import Foundation

enum RemoteDataSourceError: Error {
    case service
}

protocol DataSourceProtocol {
    func getAllCharacters(inputParam: GellAllCharactersInput?) throws -> Characters
}

final class NetworkingDataSource: DataSourceProtocol {
    private let authenticationManager: AuthenticationManager
    private let api = MarvelApi()
    private let netClient = NetworkingClient()
    
    init () {
        authenticationManager = AuthenticationManager(apiNetworking: api)
    }
    
    func getAllCharacters(inputParam: GellAllCharactersInput?) throws -> Characters {
        let path = "/v1/public/characters"
        let base = api.baseUrl
        let parameters: [String: Any] = {
           let paramsAuth = authenticationManager
                .generateApiKeyParameters()
                .dictionary ?? [:]
            let inputParams = inputParam?.dictionary ?? [:]
            return paramsAuth.merging(inputParams) { $1 }
        }()
        
        let result = netClient
            .request(url: base + path,
                     queryParams: parameters,
                     method: .get)
        switch result {
        case .success(let response):
            return try JSONDecoder().decode(Characters.self, from: response.data)
        case .failure(let error):
            switch error {
            case .unknown, .timeout, .custom:
                throw RemoteDataSourceError.service
            }
        }
    }
}

