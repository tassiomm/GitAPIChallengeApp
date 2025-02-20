//
//  NetworkRequest.swift
//  AppCore
//
//  Created by Tassio Marques on 14/02/25.
//

import Foundation

public protocol NetworkEndpoint {
    var scheme: String { get }
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem]? { get }
    
    func buildRequest() -> URLRequest?
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}
