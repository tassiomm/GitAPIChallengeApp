//
//  File.swift
//  AppCore
//
//  Created by Tassio Marques on 19/02/25.
//

import Foundation
import Combine
import NetworkingInterface

extension HTTPClient {
    /// Makes an http request call and returns a publisher with the response or a failure with NetworkError
    /// - Parameter request: a NetworkRequest
    /// - Returns: a publisher with the data and url response or a network error for a failure
    public func request<T>(_ endpoint: NetworkEndpoint) -> AnyPublisher<T, NetworkError> where T: Decodable {
        guard let urlRequest = endpoint.buildRequest() else {
            return Fail(outputType: T.self, failure: NetworkError.urlMalformed)
                .eraseToAnyPublisher()
        }

        return environment.session.dataTaskPublisher(for: urlRequest)
            .tryMap { data, response -> T in
                let aHTTPResponse = response as? HTTPURLResponse
                if let httpResponse = aHTTPResponse, !(200...299).contains(httpResponse.statusCode) {
                    if let responseError = try? self.environment.decoder.decode(ResponseError.self, from: data) {
                        throw NetworkError.responseError(responseError, statusCode: httpResponse.statusCode)
                    }
                    throw NetworkError(httpResponse.statusCode)
                }
                return try self.environment.decoder.decode(T.self, from: data)

            }
            .mapError(NetworkError.init(mapping:))
            .eraseToAnyPublisher()
    }
}
