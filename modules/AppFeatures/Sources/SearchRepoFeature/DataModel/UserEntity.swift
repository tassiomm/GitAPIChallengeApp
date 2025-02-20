//
//  UserEntity.swift
//  AppFeatures
//
//  Created by Tassio Marques on 19/02/25.
//

import Foundation

public struct UserEntity: Codable, Equatable, Hashable {
    let id: Int
    let login: String
    let avatar_url: String
}
