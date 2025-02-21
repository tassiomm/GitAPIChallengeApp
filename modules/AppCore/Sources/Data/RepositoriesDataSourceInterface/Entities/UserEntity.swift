//
//  UserEntity.swift
//  AppCore
//
//  Created by Tassio Marques on 19/02/25.
//

import Foundation

public struct UserEntity: Codable {
    public let id: Int
    public let login: String
    public let avatar_url: String
    
    public init(id: Int, login: String, avatar_url: String) {
        self.id = id
        self.login = login
        self.avatar_url = avatar_url
    }
}

#if DEBUG
public extension UserEntity {
    static var example: Self {
        UserEntity(id: 1,
                   login: "johnsp",
                   avatar_url: "http://www.someurl.com")
    }
}
#endif
