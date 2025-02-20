//
//  RepositoriesResponse.swift
//  
//
//  Created by Tassio Marques on 20/02/25.
//

import RepositoriesAPIInterface

public struct RepositoriesResponse {
    public let totalCount: Int
    public let incompleteResults: Bool
    public let items: [Repository]
    
    public init(totalCount: Int, incompleteResults: Bool, items: [Repository]) {
        self.totalCount = totalCount
        self.incompleteResults = incompleteResults
        self.items = items
    }
    
    public init(entity: RepositoriesResponseEntity) {
        self.totalCount = entity.totalCount
        self.incompleteResults = entity.incompleteResults
        self.items = entity.items.map(Repository.init(entity:))
    }
}
