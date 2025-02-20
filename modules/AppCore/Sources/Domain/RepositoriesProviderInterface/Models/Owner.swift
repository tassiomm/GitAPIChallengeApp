//
//  Owner.swift
//
//
//  Created by Tassio Marques on 20/02/25.
//

import RepositoriesAPIInterface

public struct Owner: Equatable, Hashable {
    public let id: Int
    public let url: String
    public let login: String
    public let avatarURL: String

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: Owner, rhs: Owner) -> Bool {
        return lhs.id == rhs.id
    }
    
    init(entity: OwnerEntity) {
        self.id = entity.id
        self.url = entity.url
        self.login = entity.login
        self.avatarURL = entity.avatar_url
    }
}
