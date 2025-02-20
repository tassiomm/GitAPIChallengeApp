//
//  Repository.swift
//  
//
//  Created by Tassio Marques on 20/02/25.
//

import RepositoriesAPIInterface

public struct Repository: Equatable {
    public let id: Int
    public let name, fullName: String
    public let description: String?
    public let startCount: Int
    public let forksCount: Int
    public let owner: Owner
    
    init(entity: RepositoryEntity) {
        self.id = entity.id
        self.name = entity.name
        self.fullName = entity.full_name
        self.description = entity.description
        self.startCount = entity.stargazers_count
        self.forksCount = entity.forks_count
        self.owner = Owner(entity: entity.owner)
    }
}
