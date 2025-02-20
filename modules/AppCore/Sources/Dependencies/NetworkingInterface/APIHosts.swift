//
//  API.swift
//  AppCore
//
//  Created by Tassio Marques on 14/02/25.
//

import Foundation

public enum API {
    public enum GITHUB {
        public static var baseURL: String = {
            Bundle.main.unwrappedObject(forInfoDictionaryKey: "GITHUB_API_BASE_URL_ENDPOINT")
        }()
    }
}

fileprivate extension Bundle {
    /// Unwrapp the value for info dictionary key as String. The key is expected to exist and it is expected to be a string.
    /// It triggers a fatal error if the key is not present or iif t cannot cast as a string.
    /// - Parameter key: A key in the receiver's property list.
    /// - Returns: Returns the string value associated with the specified key in the receiver's information property list.
    func unwrappedObject(forInfoDictionaryKey key: String) -> String {
        guard let value = object(forInfoDictionaryKey: key) as? String else {
            fatalError("Missing string object for key \(key)")
        }
        return value
    }
}
