//
//  SearchServiceProtocol.swift
//  AppFeatures
//
//  Created by Tassio Marques on 18/02/25.
//

import DependencyInjection
import NetworkingInterface

public protocol SearchServiceProtocol {
    func searchRepositories(language: String, page: Int, perPage: Int) async throws -> RepositoriesResponseEntity
    func fetchPullRequests(from repositoryFullName: String) async throws -> [PullRequestEntity]
}

public final actor SearchService: SearchServiceProtocol {
    private let environment: SearchRepositoriesServiceEnvironment
    
    public init(environment: SearchRepositoriesServiceEnvironment = SearchRepositoriesServiceEnvironment()) {
        self.environment = environment
    }
    
    public func searchRepositories(language: String, page: Int, perPage: Int) async throws -> RepositoriesResponseEntity {
        return try await environment.client
            .request(GithubEndpoint.searchRepositories(language: language, page: page, perPage: perPage))
    }
    
    public func fetchPullRequests(from repositoryFullName: String) async throws -> [PullRequestEntity] {
        try await environment.client.request(GithubEndpoint.fetchPullRequests(repositoryFullName: repositoryFullName))
    }
}

public struct SearchRepositoriesServiceEnvironment {
    @AppDependency var client: NetworkClient

    public init(client: AppDependency<NetworkClient> = .init()) {
        self._client = client
    }
}
