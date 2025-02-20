//
//  Model.swift
//  AppUI
//
//  Created by Tassio Marques on 17/02/25.
//

import Foundation

public extension RepositoryRowView {
    struct Model {
        let name: String
        let description: String
        let forkCount: Int
        let starsCount: Int
        let owner: Owner?
        
        public init(name: String, description: String, forkCount: Int, starsCount: Int, owner: Owner?) {
            self.name = name
            self.description = description
            self.forkCount = forkCount
            self.starsCount = starsCount
            self.owner = owner
        }
    }
    
    struct Owner {
        let avatarUrl: String
        let username: String
        
        public init(avatarUrl: String, username: String) {
            self.avatarUrl = avatarUrl
            self.username = username
        }
    }
}
