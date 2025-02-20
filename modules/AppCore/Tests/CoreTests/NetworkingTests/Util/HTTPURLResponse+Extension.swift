//
//  HTTPURLResponse+Extension.swift
//  AppCore
//
//  Created by Tassio Marques on 16/02/25.
//

import Foundation

extension HTTPURLResponse {
    /// Convenience initializer for easy mock usage. It sets a valid response attributes as default
    /// Returns nil if the intialization fails
    /// - Parameters:
    ///   - url: the string representation of the URL
    ///   - statusCode: the status code of the response
    ///   - headerFields: the header of the response
    convenience init?(url: String = "http://mockurl.com", statusCode: Int = 200, headerFields: [String: String]? = [:]) {
        guard let url = URL(string: url) else { return nil }
        self.init(url: url, statusCode: statusCode, httpVersion: nil, headerFields: headerFields)
    }
}
