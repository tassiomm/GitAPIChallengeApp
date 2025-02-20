//
//  SearchRepositoryFeatureEnvironment.swift
//  AppFeatures
//
//  Created by Tassio Marques on 19/02/25.
//

import DependencyInjection
import NetworkingInterface
import ComposableArchitecture
import SwiftUI
import AppUI

struct PullRequestsFeatureEnvironment {
    @AppDependency var searchService: SearchServiceProtocol
    
    init(searchService: AppDependency<SearchServiceProtocol> = .init()) {
        self._searchService = searchService
    }
}

@Reducer
struct PullRequestsListFeature {
    @ObservableState
    struct State: Equatable {
        @Presents var pullRequestDetails: PullRequestDetailsFeature.State?
        
        let repositoryFullName: String
        var pullRequests: [PullRequestEntity] = []
        var isLoading = false
        
        var errorMessage: String?
    }
    
    enum Action {
        case fetchPullRequests
        case fetchPullRequestsResponse(Result<[PullRequestEntity], any Error>)
        case showPullRequestDetails(url: String)
        case pullRequestDetails(PresentationAction<PullRequestDetailsFeature.Action>)
    }
    
    private let environment: PullRequestsFeatureEnvironment
    
    init(environment: PullRequestsFeatureEnvironment = PullRequestsFeatureEnvironment()) {
        self.environment = environment
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetchPullRequests:
                guard state.isLoading == false else { return .none }
                state.isLoading = true
                return .run { [url = state.repositoryFullName] send in
                    await send(.fetchPullRequestsResponse(
                        Result {
                            return try await environment.searchService.fetchPullRequests(from: url)
                        }
                    ))
                }
            case .fetchPullRequestsResponse(.success(let pullRequests)):
                state.isLoading = false
                state.pullRequests = pullRequests
                return .none
            case .fetchPullRequestsResponse(.failure(let error)):
                print(error.localizedDescription)
                return .none
            case .showPullRequestDetails(let url):
                guard let url = URL(string: url) else {
                    return .none
                }
                state.pullRequestDetails = .init(url: url)
                return .none
            case .pullRequestDetails(.dismiss):
                state.pullRequestDetails = nil
                return .none
            case .pullRequestDetails(.presented):
                return .none
            }
        }
        .ifLet(\.$pullRequestDetails, action: \.pullRequestDetails) {
            PullRequestDetailsFeature()
        }
    }
}




