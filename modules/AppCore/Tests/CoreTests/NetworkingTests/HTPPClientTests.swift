//
//  HTPPClientTests.swift
//  AppCore
//
//  Created by Tassio Marques on 16/02/25.
//

import XCTest
import Networking
import NetworkingInterface

final class HTPPClientTests: XCTestCase {
    func test_StatusCodeNot200_shouldReturnNetworkError() async {
        let sut = makeSUT(session: makeSession(statusCode: 500,
                                               result: "any data".data(using: .utf8)))
        let expect = expectation(description: #function)
        
        do {
            let _: MockResponseModel = try await sut.request(EndpointStub())
            XCTFail("Call should not succeed")
        } catch {
            XCTAssertEqual(error as? NetworkError, NetworkError.internalServerError)
            expect.fulfill()
        }
        
        await fulfillment(of: [expect], timeout: 1)
    }

    func test_statusCodeSuccessful_expectsSuccessfulDecode() async throws {
        let expectedStringResult = MockResponseModel.jsonExample(with: "test_StatusCodeSuccessful")
        let sut = makeSUT(session: makeSession(statusCode: 201, result: expectedStringResult.data(using: .utf8)))

        let response: MockResponseModel = try await sut.request(EndpointStub())
        XCTAssertEqual(response.message, "test_StatusCodeSuccessful")
    }
}

extension HTPPClientTests {
    func makeSUT(session: URLSession) -> HTTPClient {
        return HTTPClient(environment: HTTPClientEnvironment(decoder: .resolved( JSONDecoder()),
                                                             session: session))
    }
    
    /// If error is not nil, session result will be failure
    func makeSession(statusCode: Int, result: Data?, error: Error? = nil) -> URLSession {
        let response = HTTPURLResponse(statusCode: statusCode) ?? .init()
        var result: Result<Data, Error> = .success(result ?? .init())
        if let error = error {
            result = .failure(error)
        }
        return .mocking(response: response, result: result)
    }
}


