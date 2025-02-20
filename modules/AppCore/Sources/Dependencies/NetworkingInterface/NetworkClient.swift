//
//  NetworkClient.swift
//  AppCore
//
//  Created by Tassio Marques on 14/02/25.
//

import Foundation
import Combine

/// An interface to access a network client
public protocol NetworkClient {
    /// Swift concurrecy solution
    func request<T>(_ endpoint: NetworkEndpoint) async throws -> T where T: Decodable
    
    /// Swift Combine solution
    func request<T>(_ endpoint: NetworkEndpoint) -> AnyPublisher<T, Error> where T: Decodable
}
