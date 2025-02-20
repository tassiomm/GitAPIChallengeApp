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
    @AppDependency var repositoriesProvider: RepositoriesProviderProtocol
    
    init(repositoriesProvider: AppDependency<RepositoriesProviderProtocol> = .init()) {
        self._repositoriesProvider = repositoriesProvider
    }
}

@Reducer
struct PullRequestsListFeature {
    @ObservableState
    struct State: Equatable {
        @Presents var pullRequestDetails: PullRequestDetailsFeature.State?
        @Presents public var alert: AlertState<Action.Alert>?
        
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
        case alert(PresentationAction<Alert>)
        
        public enum Alert: Equatable, Sendable {
            case retry
        }
    }

    private let environment: PullRequestsFeatureEnvironment
    init(environment: PullRequestsFeatureEnvironment = PullRequestsFeatureEnvironment()) {
        self.environment = environment
    }

    @Dependency(\.dismiss) var dismiss
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetchPullRequests:
                guard state.isLoading == false else { return .none }
                state.isLoading = true
                return .run { [url = state.repositoryFullName] send in
                    await send(.fetchPullRequestsResponse(
                        Result {
                            return try await environment
                                .repositoriesProvider.fetchPullRequests(from: url)
                        }
                    ))
                }
            case .fetchPullRequestsResponse(.success(let pullRequests)):
                state.isLoading = false
                state.pullRequests = pullRequests
                return .none
            case .fetchPullRequestsResponse(.failure(let error)):
                state.isLoading = false
                state.alert = AlertState {
                    TextState(error.localizedDescription)
                } actions: {
                    ButtonState(action: .retry, label: { TextState(Localized("button_retry")) })
                    ButtonState(role: .cancel, label: { TextState(Localized("button_cancel"))})
                }
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
            case .alert(.presented(.retry)):
                return .send(.fetchPullRequests)
            case .alert(.dismiss):
                return .run { _ in await self.dismiss() }
            }
        }
        .ifLet(\.$alert, action: \.alert)
        .ifLet(\.$pullRequestDetails, action: \.pullRequestDetails) {
            PullRequestDetailsFeature()
        }
    }
}




