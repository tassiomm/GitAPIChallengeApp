//
//  SearchResponse.swift
//  githubapi-challenge
//
//  Created by Tassio Marques on 17/02/25.
//

import Foundation

// TODO: Move to correct layer
public struct RepositoriesResponseEntity: Codable {
    public let totalCount: Int
    public let incompleteResults: Bool
    public let items: [RepositoryEntity]

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
    
    public init(totalCount: Int, incompleteResults: Bool, items: [RepositoryEntity]) {
        self.totalCount = totalCount
        self.incompleteResults = incompleteResults
        self.items = items
    }
}

// MARK: - Item
public struct RepositoryEntity: Codable, Equatable, Hashable {
    public let id: Int
    public let name, full_name: String
    public let description: String?
    public let stargazers_count: Int
    public let forks_count: Int
    public let owner: OwnerEntity
}

public struct OwnerEntity: Codable, Equatable, Hashable {
    public let id: Int
    public let url: String
    public let login: String
    public let avatar_url: String
    public let name: String?

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: OwnerEntity, rhs: OwnerEntity) -> Bool {
        return lhs.id == rhs.id
    }
}
