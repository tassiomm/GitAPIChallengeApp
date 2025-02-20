//
//  MockResponseModel.swift
//  AppCore
//
//  Created by Tassio Marques on 17/02/25.
//

import Foundation

struct MockResponseModel: Decodable {
    let message: String
    
    static func jsonExample(with message: String) -> String {
        return String(format: #"""
        {
            "message": "%@"
        }
        """#, message)
    }
}
