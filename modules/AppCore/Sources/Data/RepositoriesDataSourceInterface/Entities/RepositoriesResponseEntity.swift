//
//  SearchResponse.swift
//  AppCore
//
//  Created by Tassio Marques on 17/02/25.
//

import Foundation

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
