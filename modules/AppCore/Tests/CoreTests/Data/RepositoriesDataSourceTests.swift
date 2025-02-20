//
//  RepositoriesDataSourceTests.swift
//
//
//  Created by Tassio Marques on 20/02/25.
//

import Foundation
import XCTest
import NetworkingInterface
import RepositoriesAPI
import RepositoriesAPIInterface

final class RepositoriesDataSourceTests: XCTestCase {
    func test_fetchRepositories_validData_expectSuccess() async throws {
        let entity = RepositoriesResponseEntity(totalCount: 105,
                                                incompleteResults: false,
                                                items: [])
        let client = NetworkClientStub(requestConcurrencyResult: .success(entity))
        let sut = makeSUT(client)
        
        let result = try await sut.searchRepositories(language: "", page: 1, perPage: 10)
        
        XCTAssertEqual(result.totalCount, 105)
        XCTAssertEqual(result.items.count, 0)
    }
    
    func test_fetchRepositories_returnError_expectFailure() async throws {
        let client = NetworkClientStub(requestConcurrencyResult: .failure(NetworkError.badRequest))
        let sut = makeSUT(client)
        
        do {
            _ = try await sut.searchRepositories(language: "", page: 1, perPage: 10)
            XCTFail("It doesn't expect search to succeeed")
        } catch {
            XCTAssertEqual(error as? NetworkError, NetworkError.badRequest)
        }
    }
    
    func test_fetchPullRequests_validData_expectSuccess() async throws {
        let entities = [PullRequestEntity(id: 18, 
                                          title: "Fix bug 1340",
                                          body: "",
                                          html_url: "",
                                          user: .init(id: 1, login: "", avatar_url: ""))]
        let client = NetworkClientStub(requestConcurrencyResult: .success(entities))
        let sut = makeSUT(client)
        
        let result = try await sut.fetchPullRequests(from: "user/repo")
        
        XCTAssertEqual(result.first?.id, 18)
        XCTAssertEqual(result.first?.title, "Fix bug 1340")
    }
    
    func test_fetchPullRequests_returnError_expectFailure() async throws {
        let client = NetworkClientStub(requestConcurrencyResult: .failure(NetworkError.badRequest))
        let sut = makeSUT(client)
        
        do {
            _ = try await sut.fetchPullRequests(from: "")
            XCTFail("It doesn't expect search to succeeed")
        } catch {
            XCTAssertEqual(error as? NetworkError, NetworkError.badRequest)
        }
    }
}

extension RepositoriesDataSourceTests {
    func makeSUT(_ networkClient: NetworkClient) -> RepositoriesDataSource {
        RepositoriesDataSource(environment: .init(client: .resolved(networkClient)))
    }
}
