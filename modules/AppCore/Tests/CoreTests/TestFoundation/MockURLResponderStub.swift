//
//  MockURLResponderStub 2.swift
//  AppCore
//
//  Created by Tassio Marques on 16/02/25.
//


import Foundation

/// Stub used to mock url response and result
enum MockURLResponderStub: MockURLResponder {
    static var resultToBeReturned: Result<Data, Error> = .success(.init())
    static func respond(to _: URLRequest) throws -> Data { try resultToBeReturned.get() }
    
    static var responseToBeReturned: URLResponse = .init()
    static func response(for _: URLRequest) -> URLResponse { responseToBeReturned }
    
    static var shouldStaleStatusToBeReturned: Bool = false
    static func shouldStale() -> Bool { shouldStaleStatusToBeReturned }
}