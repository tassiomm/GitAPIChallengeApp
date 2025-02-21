//
//  File.swift
//  
//
//  Created by Tassio Marques on 20/02/25.
//

import RepositoriesRepositoryInterface

final class RepositoriesRepositoryStub: RepositoriesRepositoryProtocol {
    var searchRepositoriesResponse: RepositoriesResponse = RepositoriesResponse(entity: .init(totalCount: 0, incompleteResults: false, items: []))
    func searchRepositories(language: String, page: Int, perPage: Int) async throws -> RepositoriesRepositoryInterface.RepositoriesResponse {
        return searchRepositoriesResponse
    }
    
    var fetchPullRequestsResponse: [PullRequest] = []
    func fetchPullRequests(from repositoryFullName: String) async throws -> [PullRequest] {
        return fetchPullRequestsResponse
    }
}
