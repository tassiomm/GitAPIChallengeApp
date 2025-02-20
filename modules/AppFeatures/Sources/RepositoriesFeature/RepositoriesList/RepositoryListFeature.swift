//
//  SearchRepositoryFeatureEnvironment.swift
//  AppFeatures
//
//  Created by Tassio Marques on 18/02/25.
//

import DependencyInjection
import NetworkingInterface
import ComposableArchitecture
import SwiftUI
import AppUI
import RepositoriesProviderInterface

struct SearchRepositoryFeatureEnvironment {
    @AppDependency var repositoriesProvider: RepositoriesProviderProtocol
    
    init(repositoriesProvider: AppDependency<RepositoriesProviderProtocol> = .init()) {
        self._repositoriesProvider = repositoriesProvider
    }
}

@Reducer
struct RepositoryListFeature {
    @ObservableState
    struct State: Equatable {
        @Presents public var pullRequests: PullRequestsListFeature.State?
        
        let language: String
        
        var isLoading = false
        var page = 1
        var repositories: [Repository] = []
        
        var errorMessage: String?
    }
    
    enum Action {
        case fetchPageIfNeeded(index: Int)
        case fetchNewPage(reload: Bool)
        case fetchNewPageResponse(Result<[Repository], any Error>)
        
        // pullRequests destination
        case showPullRequests(repositoryFullName: String)
        case pullRequests(PresentationAction<PullRequestsListFeature.Action>)
    }

    private let environment: SearchRepositoryFeatureEnvironment
    private let batchSize = 80
    
    init(environment: SearchRepositoryFeatureEnvironment = SearchRepositoryFeatureEnvironment()) {
        self.environment = environment
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetchPageIfNeeded(let index):
                let thresholdIndex = batchSize / 2
                if index >= state.repositories.count - thresholdIndex - 1, state.errorMessage == nil {
                    return .send(.fetchNewPage(reload: false))
                }
                return .none
            case .fetchNewPage(let reload):
                if state.isLoading {
                    return .none
                }
                state.isLoading = true
                if reload {
                    state.page = 1
                    state.repositories = []
                }
                return .run { [page = state.page, language = state.language] send in
                    await send(.fetchNewPageResponse(
                        Result {
                            let response: RepositoriesResponse = try await environment
                                .repositoriesProvider.searchRepositories(language: language,
                                                                         page: page,
                                                                         perPage: batchSize)
                            return response.items
                        }
                    ))
                }
            case let .fetchNewPageResponse(.success(repositories)):
                state.errorMessage = nil
                state.isLoading = false
                state.page += 1
                state.repositories.append(contentsOf: repositories)
                return .none
            case let .fetchNewPageResponse(.failure(error)):
                state.isLoading = false
                state.errorMessage = error.localizedDescription
                return .none
            case .showPullRequests(let repositoryFullName):
                state.pullRequests = .init(repositoryFullName: repositoryFullName)
                return .none
            case .pullRequests:
                return .none
            }
        }
        .ifLet(\.$pullRequests, action: \.pullRequests) {
            PullRequestsListFeature()
        }
    }
}

