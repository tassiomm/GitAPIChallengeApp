//
//  NetworkErrorTests.swift
//  AppCore
//
//  Created by Tassio Marques on 16/02/25.
//

import XCTest
import NetworkingInterface

final class NetworkErrorTests: XCTestCase {
    func test_mapStatusCode_expectsUnreacheableError() {
        let sut = NetworkError(-1009)
        XCTAssertEqual(sut, .unreachable)
    }
    
    func test_mapStatusCode_expectsNotFoundError() {
        let sut = NetworkError(404)
        XCTAssertEqual(sut, .notFound)
    }
    
    func test_mapStatusCode_expectsInternalServerError() {
        let sut = NetworkError(500)
        XCTAssertEqual(sut, .internalServerError)
    }
    
    func test_mapStatusCode_expectsHTTPError402() {
        let sut = NetworkError(402)
        XCTAssertEqual(sut, .unmapped(nil))
    }
    
    func test_mapStatusCode_expectsNetworkErrorForbidden() {
        let sut = NetworkError(403)
        XCTAssertEqual(sut, .forbidden)
    }
    
    func test_mapStatusCode_expectsHTTPError503() {
        let sut = NetworkError(503)
        XCTAssertEqual(sut, .unmapped(nil))
    }
    
    func test_mapError_expectsNetworkError() {
        let sut = NetworkError(mapping: NetworkError.badRequest)
        XCTAssertEqual(sut, .badRequest)
    }
    
    func test_mapError_expectsStatusCodeError() {
        let sut = NetworkError(mapping: URLError.init(URLError.Code(rawValue: 500)))
        XCTAssertEqual(sut, .internalServerError)
    }
    
    func test_mapError_expectsUnknownNetworkError() {
        let err = NSError(domain: "2", code: 3,
                          userInfo: [NSLocalizedDescriptionKey:"Something unexpected happened"])
        let sut = NetworkError(mapping: err)
        XCTAssertEqual(sut, .unmapped(err.localizedDescription))
    }
}
