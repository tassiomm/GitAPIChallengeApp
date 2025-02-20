//
//  OwnerEntity.swift
//  AppCore
//
//  Created by Tassio Marques on 20/02/25.
//

import Foundation

public struct OwnerEntity: Codable {
    public let id: Int
    public let url: String
    public let login: String
    public let avatar_url: String
    public let name: String?

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: OwnerEntity, rhs: OwnerEntity) -> Bool {
        return lhs.id == rhs.id
    }
}
