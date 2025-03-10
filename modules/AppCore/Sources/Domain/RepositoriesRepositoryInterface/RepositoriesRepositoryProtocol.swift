//
//  File.swift
//  
//
//  Created by Tassio Marques on 20/02/25.
//

import Foundation
import NetworkingInterface
import RepositoriesAPIInterface

public protocol RepositoriesRepositoryProtocol {
    func searchRepositories(language: String, page: Int, perPage: Int) async throws -> RepositoriesResponse
    func fetchPullRequests(from repositoryFullName: String) async throws -> [PullRequest]
}
