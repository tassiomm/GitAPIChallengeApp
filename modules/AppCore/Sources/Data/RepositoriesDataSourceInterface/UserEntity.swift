//
//  UserEntity.swift
//  AppFeatures
//
//  Created by Tassio Marques on 19/02/25.
//

import Foundation

public struct UserEntity: Codable, Equatable, Hashable {
    public let id: Int
    public let login: String
    public let avatar_url: String
}
