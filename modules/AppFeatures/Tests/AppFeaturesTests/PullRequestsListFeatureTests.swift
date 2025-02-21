//
//  File.swift
//  
//
//  Created by Tassio Marques on 20/02/25.
//

import XCTest
@testable import RepositoriesFeature
import ComposableArchitecture
import RepositoriesRepositoryInterface

final class PullRequestsListFeatureTests: XCTestCase {
    private var stub = RepositoriesRepositoryStub()
    
    @MainActor
    func test_actionFetchPullRequests_expectUpdate() async {
        let url = URL(string: "http://www.google.com")!
        let store = makeSUT(url: url, repositoriesRepositoryStub: stub)
        let expectedResponse = stub.fetchPullRequestsResponse
        
        await store.send(.fetchPullRequests) {
            $0.isLoading = true
        }
        
        await store.receive(\.fetchPullRequestsResponse) {
            $0.isLoading = false
            $0.pullRequests = expectedResponse
        }
    }
    
    @MainActor
    func test_actionFetchPullRequestsResponse_expectUpdateSuccess() async {
        let url = URL(string: "http://www.google.com")!
        let store = makeSUT(url: url, repositoriesRepositoryStub: stub)
        
        let pullRequest = PullRequest.example
        await store.send(.fetchPullRequestsResponse(.success([pullRequest]))) {
            $0.isLoading = false
            $0.pullRequests = [pullRequest]
        }
    }
    
    @MainActor
    func test_actionFetchPullRequestsResponse_expectUpdateFailure() async {
        let url = URL(string: "http://www.google.com")!
        let store = makeSUT(url: url, repositoriesRepositoryStub: stub)
        
        let expectedError = NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "error description"])
        await store.send(.fetchPullRequestsResponse(.failure(expectedError))) {
            $0.isLoading = false
            $0.alert = AlertState {
                TextState(expectedError.localizedDescription)
            } actions: {
                ButtonState(action: .retry, label: { TextState(Localized("button_retry")) })
                ButtonState(role: .cancel, label: { TextState(Localized("button_cancel"))})
            }
        }
    }
    
    @MainActor
    func test_actionShowPullRequestDetails_expectUpdate() async {
        let url = URL(string: "http://www.google.com")!
        let store = makeSUT(url: url, repositoriesRepositoryStub: stub)
        
        await store.send(.showPullRequestDetails(url: ""))
        
        let expectedURL = "http://www.validurl.com"
        await store.send(.showPullRequestDetails(url: expectedURL)) {
            $0.pullRequestDetails = .init(url: URL(string: expectedURL)!)
        }
    }
    
    @MainActor
    func test_actionPullRequestDetails_expectUpdate() async {
        let url = URL(string: "http://www.google.com")!
        let store = makeSUT(url: url, repositoriesRepositoryStub: stub)
        
        let expectedURL = "http://www.validurl.com"
        await store.send(.showPullRequestDetails(url: expectedURL)) {
            $0.pullRequestDetails = .init(url: URL(string: expectedURL)!)
        }
        
        await store.send(.pullRequestDetails(.presented(.dismiss)))

        await store.send(.pullRequestDetails(.dismiss)) {
            $0.pullRequestDetails = nil
        }
    }
    
    @MainActor
    func test_actionAlert_expectUpdate() async {
        let url = URL(string: "http://www.google.com")!
        let store = makeSUT(url: url, repositoriesRepositoryStub: stub)
        let expectedResponse = stub.fetchPullRequestsResponse
        
        // call to present alert
        let expectedError = NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "error description"])
        await store.send(.fetchPullRequestsResponse(.failure(expectedError))) {
            $0.isLoading = false
            $0.alert = AlertState {
                TextState(expectedError.localizedDescription)
            } actions: {
                ButtonState(action: .retry, label: { TextState(Localized("button_retry")) })
                ButtonState(role: .cancel, label: { TextState(Localized("button_cancel"))})
            }
        }
        
        // Actual State (.alert)
        await store.send(.alert(.presented(.retry))) {
            $0.alert = nil
        }
        
        // Expects to receive fetchPullRequests
        await store.receive(\.fetchPullRequests) {
            $0.isLoading = true
        }
        
        // Then, expects to receive fetchPullRequestsResponse
        await store.receive(\.fetchPullRequestsResponse) {
            $0.isLoading = false
            $0.pullRequests = expectedResponse
        }
    }
    
    private func makeSUT(url: URL,
                         repositoriesRepositoryStub: RepositoriesRepositoryStub)
    -> TestStore<PullRequestsListFeature.State, PullRequestsListFeature.Action> {
        TestStore(initialState: PullRequestsListFeature.State(repositoryFullName: "")) {
            PullRequestsListFeature(environment: .init(repositoriesRepository:
                    .resolved(RepositoriesRepositoryStub())))
        }
    }
}
