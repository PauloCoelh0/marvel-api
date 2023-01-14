//
//  Keys_Root.swift
//  Marvel Comics
//
//  Created by Paulo Coelho on 14/01/2023.
//

import Foundation

protocol ApiNetworkingProtocol {
    var baseUrl: String { get }
    var privateApiKey: String { get }
    var publicApiKey: String { get }
}

struct MarvelApi: ApiNetworkingProtocol {
    let baseUrl: String = "https://gateway.marvel.com"
    let privateApiKey = "7a6f2c82f7d2bc73a03a19c498ef6b267642813e"
    let publicApiKey = "92dc64682ab997a910687ab97b00c6dc"
}

