//
//  File.swift
//  
//
//  Created by Tassio Marques on 20/02/25.
//

import Foundation
import NetworkingInterface
import Combine

struct NetworkClientStub: NetworkClient {
    var requestConcurrencyResult: Result<Codable, Error>?
    func request<T>(_ endpoint: any NetworkEndpoint) async throws -> T where T : Decodable {
        guard let result = try requestConcurrencyResult?.get() as? T else {
            fatalError("Stub not implemented correctly")
        }
        return result
    }
    
    var requestCombine: Result<Codable, NetworkError>?
    func request<T>(_ endpoint: any NetworkEndpoint) -> AnyPublisher<T, Error> where T : Decodable {
        switch requestCombine! {
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        case .success(let output):
            return Just(output as! T)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}
