//
//  MockURLResponder.swift
//  AppCore
//
//  Created by Tassio Marques on 16/02/25.
//

import Foundation

protocol MockURLResponder {
    static func shouldStale() -> Bool
    static func respond(to request: URLRequest) throws -> Data
    static func response(for request: URLRequest) -> URLResponse
}

final class URLProtocolMock<Responder: MockURLResponder>: URLProtocol {
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    /// If shoudState returns true, responder won't finish.
    override func startLoading() {
        guard let client = client, Responder.shouldStale() == false else { return }
        
        let response = Responder.response(for: request)
        client.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        
        do {
            let data = try Responder.respond(to: request)
            client.urlProtocol(self, didLoad: data)
        } catch {
            client.urlProtocol(self, didFailWithError: error)
        }
        
        client.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {}
}
