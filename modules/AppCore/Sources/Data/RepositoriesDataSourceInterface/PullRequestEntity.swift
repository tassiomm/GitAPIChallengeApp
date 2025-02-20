//
//  PullRequest.swift
//  AppFeatures
//
//  Created by Tassio Marques on 19/02/25.
//

public struct PullRequestEntity: Decodable, Equatable, Identifiable {
    public let id: Int
    public let title: String
    public let body: String?
    public let html_url: String
    public let user: UserEntity
}
