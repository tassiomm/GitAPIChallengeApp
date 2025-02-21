//
//  User.swift
//  
//
//  Created by Tassio Marques on 20/02/25.
//

import RepositoriesAPIInterface

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

#if DEBUG
extension User {
    static var example: Self {
        User(entity: .init(id: 1,
                           login: "johnsp",
                           avatar_url: "http://www.someurl.com"))
    }
}
#endif
