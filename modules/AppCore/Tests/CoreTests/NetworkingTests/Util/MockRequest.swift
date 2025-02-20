//
//  MockRequest.swift
//  AppCore
//
//  Created by Tassio Marques on 16/02/25.
//

import Foundation
import NetworkingInterface

struct EndpointStub: NetworkEndpoint {
    var scheme: String { "" }
    var baseURL: String { "" }
    let path: String = "/"
    let method: HTTPMethod = .get
    var queryItems: [URLQueryItem]?
    
    var urlRequest: URLRequest = .mocking()
    func buildRequest() -> URLRequest? {
        return urlRequest
    }
}

extension URLRequest {
    static func mocking(_ urlString: String = "https://google.com") -> Self {
        return URLRequest(url: .init(string: urlString)!)
    }
}
