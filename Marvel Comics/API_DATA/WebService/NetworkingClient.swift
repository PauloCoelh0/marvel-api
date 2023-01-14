//
//  NetworkingClient.swift
//  Marvel Comics
//
//  Created by Paulo Coelho on 14/01/2023.
//

import Foundation

enum ServiceError: Error {
    case unknown
    case timeout
    case custom(_ error: String)
}

enum RequestType {
    case get
    case post
}

struct Response {
    let data: Data
    let statusCode: Int
}
//teste

final class NetworkingClient: NSObject {
    func request(url: String, queryParams: [String: Any], method: RequestType) -> Result<Response, ServiceError> {
        guard var urlComponent = URLComponents(string: url) else { return .failure(ServiceError.unknown) }
        urlComponent.queryItems = queryParams
            .map { URLQueryItem(name: $0.key, value: String(describing: $0.value)) }
        
        guard let url = urlComponent.url else { return .failure(ServiceError.unknown) }
        var urlRequest = URLRequest(url: url)
        switch method {
        case .get:
            urlRequest.httpMethod = "GET"
        case .post:
            urlRequest.httpMethod = "POST"
        }
        var result: Result<Response, ServiceError> = .failure(ServiceError.timeout)
        let session = URLSession(configuration: .default)
        let group = DispatchGroup()
        group.enter()
        session.dataTask(with: urlRequest) { data, response, error in
            defer {
                group.leave()
            }
            if error == nil, let response = response as? HTTPURLResponse, let data = data {
                switch response.statusCode {
                case 200:
                    result = .success(Response(data: data, statusCode: response.statusCode))
                default:
                    result = .failure(ServiceError.unknown)
                }
            }
        }.resume()
        group.wait()
        return result
    }
}
