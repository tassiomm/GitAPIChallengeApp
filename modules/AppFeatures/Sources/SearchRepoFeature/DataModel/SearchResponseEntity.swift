//
//  SearchResponse.swift
//  githubapi-challenge
//
//  Created by Tassio Marques on 17/02/25.
//

import Foundation

// TODO: Move to correct layer
public struct RepositoriesResponseEntity: Codable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [RepositoryEntity]

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}

// MARK: - Item
public struct RepositoryEntity: Codable, Equatable, Hashable {
    let id: Int
    let name, full_name: String
    let description: String?
    
    let stargazers_count: Int
    let forks_count: Int
    
    let owner: OwnerEntity
}

public struct OwnerEntity: Codable, Equatable, Hashable {
    let id: Int
    let url: String
    let login: String
    let avatar_url: String
    let name: String?

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: OwnerEntity, rhs: OwnerEntity) -> Bool {
        return lhs.id == rhs.id
    }
}
