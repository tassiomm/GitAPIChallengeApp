//
//  PullRequest.swift
//  AppFeatures
//
//  Created by Tassio Marques on 19/02/25.
//

public struct PullRequestEntity: Codable, Equatable, Identifiable {
    public let id: Int
    public let title: String
    public let body: String?
    public let html_url: String
    public let user: UserEntity
    
    public init(id: Int, title: String, body: String?, html_url: String, user: UserEntity) {
        self.id = id
        self.title = title
        self.body = body
        self.html_url = html_url
        self.user = user
    }
}
