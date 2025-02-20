//
//  RepositoriesDataSource.swift
//  
//
//  Created by Tassio Marques on 20/02/25.
//

import Foundation
import DependencyInjection
import NetworkingInterface
import RepositoriesAPIInterface

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
