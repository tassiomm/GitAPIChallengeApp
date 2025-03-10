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
import AppFoundation

public final actor RepositoriesDataSource: RepositoriesDataSourceProtocol {
    private let environment: RepositoriesDataSourceEnvironment
    
    public init(environment: RepositoriesDataSourceEnvironment = .init()) {
        self.environment = environment
    }
    
    public func searchRepositories(language: String, page: Int, perPage: Int) async throws -> RepositoriesResponseEntity {
        let endpoint = RepositoriesEndpoint.searchRepositories(language: language, page: page, perPage: perPage)
        let key = "searchRepositories:\(language):\(page):\(perPage)"

        if let cache = environment.repositoryPageCache.getValue(forKey: key) {
            return cache
        }
        
        let response: RepositoriesResponseEntity = try await environment.client.request(endpoint)
        environment.repositoryPageCache.setValue(response, forKey: key)
        
        return response
    }
    
    public func fetchPullRequests(from repositoryFullName: String) async throws -> [PullRequestEntity] {
        let endpoint = RepositoriesEndpoint.fetchPullRequests(repositoryFullName: repositoryFullName)
        
        let key = repositoryFullName
        if let cache = environment.pullRequestsCache.getValue(forKey: key) {
            return cache
        }

        let response: [PullRequestEntity] = try await environment.client.request(endpoint)
        environment.pullRequestsCache.setValue(response, forKey: key)
        return response
    }
}

public struct RepositoriesDataSourceEnvironment {
    @AppDependency var client: NetworkClient
    @AppDependency var repositoryPageCache: Cache<RepositoriesResponseEntity>
    @AppDependency var pullRequestsCache: Cache<[PullRequestEntity]>

    public init(client: AppDependency<NetworkClient> = .init(),
                repositoryPageCache: AppDependency<Cache<RepositoriesResponseEntity>> = .init(),
                pullRequestsCache: AppDependency<Cache<[PullRequestEntity]>> = .init()) {
        self._client = client
        self._repositoryPageCache = repositoryPageCache
        self._pullRequestsCache = pullRequestsCache
    }
}
