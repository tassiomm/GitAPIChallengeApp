//
//  File.swift
//  
//
//  Created by Tassio Marques on 20/02/25.
//

import Foundation
import DependencyInjection
import RepositoriesProviderInterface
import RepositoriesAPIInterface

public final actor RepositoriesProvider: RepositoriesProviderProtocol {
    private let environment: RepositoriesProviderEnvironment

    public init(environment: RepositoriesProviderEnvironment = .init()) {
        self.environment = environment
    }
    
    public func searchRepositories(language: String, page: Int, perPage: Int) async throws -> RepositoriesResponse {
        let response = try await environment.dataSource.searchRepositories(language: language, page: page, perPage: perPage)
        return .init(entity: response)
    }
    
    public func fetchPullRequests(from repositoryFullName: String) async throws -> [PullRequest] {
        try await environment.dataSource.fetchPullRequests(from: repositoryFullName)
            .map(PullRequest.init(entity:))
    }
}

public struct RepositoriesProviderEnvironment {
    @AppDependency var dataSource: RepositoriesDataSourceProtocol
    
    public init(dataSource: AppDependency<RepositoriesDataSourceProtocol> = .init()) {
        self._dataSource = dataSource
    }
}
