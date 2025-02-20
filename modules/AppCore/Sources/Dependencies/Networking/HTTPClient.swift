//
//  HTTPClient.swift
//  AppCore
//
//  Created by Tassio Marques on 14/02/25.
//

import Foundation
import NetworkingInterface
import DependencyInjection
import Combine

/// A implementation of a NetworkClient to make HTTP request calls
public final class HTTPClient: NetworkClient {
    private(set) var environment: HTTPClientEnvironment
    
    public init(environment: HTTPClientEnvironment = HTTPClientEnvironment()) {
        self.environment = environment
    }
    
    /// Makes an http request call and returns the decoded value or throws a NetworkError
    /// - Parameter request: a NetworkRequest
    /// - Returns: the decoded value or a network error for a failure
    public func request<T>(_ endpoint: any NetworkingInterface.NetworkEndpoint) async throws -> T where T : Decodable {
        guard let urlRequest = endpoint.buildRequest() else {
            throw NetworkError.urlMalformed
        }
        
        do {
            let (data, response) = try await environment.session.data(for: urlRequest)
            
            if let httpResponse = response as? HTTPURLResponse,
                !(200...299).contains(httpResponse.statusCode) {
                
                if let responseError = try? self.environment.decoder.decode(ResponseError.self, from: data) {
                    throw NetworkError.responseError(responseError, statusCode: httpResponse.statusCode)
                }
                
                throw NetworkError(httpResponse.statusCode)
            }
            
            return try self.environment.decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError(mapping: error)
        }
    }
    
    // MARK: - ReactiveSolution[Exemple]
    
    /// Makes an http request call and returns a publisher with the response or a failure with NetworkError
    /// - Parameter request: a NetworkRequest
    /// - Returns: a publisher with the data and url response or a network error for a failure
    public func request<T>(_ endpoint: NetworkEndpoint) -> AnyPublisher<T, Error> where T: Decodable {
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

public struct HTTPClientEnvironment {
    @AppDependency var decoder: DataDecoder
    let session: URLSession
    
    public init(decoder: AppDependency<DataDecoder> = .init(),
                session: URLSession = .shared) {
        self._decoder = decoder
        self.session = session
    }
}


