//
//  File.swift
//  AppCore
//
//  Created by Tassio Marques on 16/02/25.
//

import Foundation

extension URLSession {
    convenience init<T: MockURLResponder>(mockResponder _: T.Type) {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolMock<T>.self]
        self.init(configuration: configuration)
        URLProtocol.registerClass(URLProtocolMock<T>.self)
    }
    
    public static func mocking(
        response: URLResponse = .init(),
        result: Result<Data, Error> = .success(.init()),
        shouldStale: Bool = false) -> URLSession {
        MockURLResponderStub.responseToBeReturned = response
        MockURLResponderStub.resultToBeReturned = result
        MockURLResponderStub.shouldStaleStatusToBeReturned = shouldStale
        return .init(mockResponder: MockURLResponderStub.self)
    }
}
