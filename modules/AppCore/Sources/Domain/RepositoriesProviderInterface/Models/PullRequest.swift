//
//  PullRequest.swift
//  
//
//  Created by Tassio Marques on 20/02/25.
//

import RepositoriesAPIInterface

public struct PullRequest: Equatable, Identifiable {
    public let id: Int
    public let title: String
    public let body: String?
    public let htmlURL: String
    public let user: User
    
    public init(entity: PullRequestEntity) {
        self.id = entity.id
        self.title = entity.title
        self.body = entity.body
        self.htmlURL = entity.html_url
        self.user = .init(entity: entity.user)
    }
}

public struct User: Equatable, Hashable {
    public let id: Int
    public let login: String
    public let avatarURL: String
    
    public init(entity: UserEntity) {
        self.id = entity.id
        self.login = entity.login
        self.avatarURL = entity.avatar_url
    }
}
