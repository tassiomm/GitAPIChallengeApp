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

#if DEBUG
public extension PullRequest {
    static var example: Self {
        PullRequest(entity: .init(id: 1, title: "tcafork",
                                  body: "This is my TCA fork",
                                  html_url: "http://github.api.com/johnsp/tcafork/pulls",
                                  user: UserEntity.example))
    }
}
#endif
