//
//  SearchServiceProtocol.swift
//  AppFeatures
//
//  Created by Tassio Marques on 18/02/25.
//

import DependencyInjection
import NetworkingInterface

public protocol RepositoriesDataSourceProtocol {
    func searchRepositories(language: String, page: Int, perPage: Int) async throws -> RepositoriesResponseEntity
    func fetchPullRequests(from repositoryFullName: String) async throws -> [PullRequestEntity]
}

public final actor RepositoriesDataSource: RepositoriesDataSourceProtocol {
    private let environment: RepositoriesDataSourceEnvironment
    
    public init(environment: RepositoriesDataSourceEnvironment = .init()) {
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

public struct RepositoriesDataSourceEnvironment {
    @AppDependency var client: NetworkClient

    public init(client: AppDependency<NetworkClient> = .init()) {
        self._client = client
    }
}

/// --------------

public protocol RepositoriesProviderProtocol {
    func searchRepositories(language: String, page: Int, perPage: Int) async throws -> RepositoriesResponseEntity
    func fetchPullRequests(from repositoryFullName: String) async throws -> [PullRequestEntity]
}

public final actor RepositoriesProvider: RepositoriesProviderProtocol {
    private let environment: RepositoriesProviderEnvironment

    public init(environment: RepositoriesProviderEnvironment = .init()) {
        self.environment = environment
    }
    
    public func searchRepositories(language: String, page: Int, perPage: Int) async throws -> RepositoriesResponseEntity {
        return try await environment.dataSource
            .searchRepositories(language: language, page: page, perPage: perPage)
    }
    
    public func fetchPullRequests(from repositoryFullName: String) async throws -> [PullRequestEntity] {
        try await environment.dataSource
            .fetchPullRequests(from: repositoryFullName)
    }
}

public struct RepositoriesProviderEnvironment {
    @AppDependency var dataSource: RepositoriesDataSourceProtocol
    
    public init(dataSource: AppDependency<RepositoriesDataSourceProtocol> = .init()) {
        self._dataSource = dataSource
    }
}
