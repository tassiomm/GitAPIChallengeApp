//
//  PullRequest.swift
//  AppFeatures
//
//  Created by Tassio Marques on 19/02/25.
//

public struct PullRequestEntity: Decodable, Equatable, Identifiable {
    public let id: Int
    let title: String
    let body: String?
    let html_url: String
    let user: UserEntity
}
