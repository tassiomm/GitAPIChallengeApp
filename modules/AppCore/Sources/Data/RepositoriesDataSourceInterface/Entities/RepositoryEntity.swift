//
//  RepositoryEntity.swift
//  AppCore
//
//  Created by Tassio Marques on 20/02/25.
//

import Foundation

public struct RepositoryEntity: Codable {
    public let id: Int
    public let name, full_name: String
    public let description: String?
    public let stargazers_count: Int
    public let forks_count: Int
    public let owner: OwnerEntity
}
