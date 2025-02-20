//
//  NetworkError.swift
//  AppCore
//
//  Created by Tassio Marques on 14/02/25.
//

import Foundation

public enum NetworkError: Error, Equatable, LocalizedError {
    case urlMalformed
    case unreachable
    case notFound
    case badRequest
    case internalServerError
    case forbidden
    case responseError(ResponseError, statusCode: Int)
    case unmapped(String?)
    
    public var errorDescription: String? {
        switch self {
        case .urlMalformed:
            return "The URL is not in an acceptable form"
        case .unreachable:
            return "The Internet connection appears to be offline."
        case .notFound:
            return "The server cannot find the requested resource."
        case .badRequest:
            return "The request is not valid."
        case .internalServerError:
            return "There's something wrong with the server. Try again later"
        case .forbidden:
            return "Not allowed to perform this operation"
        case let  .responseError(responseError, statusCode):
            return "\(responseError.message). Status Code: \(statusCode)"
        case .unmapped:
            return "A unexpected network error happened."
        }
    }
}

extension NetworkError {
    public init(_ statusCode: Int) {
        switch statusCode {
        case -1009:
            self = .unreachable
        case 403:
            self = .forbidden
        case 404:
            self = .notFound
        case 500:
            self = .internalServerError
        default:
            self = .unmapped(nil)
        }
    }
    
    public init(mapping error: Error) {
        switch error {
        case let networkError as NetworkError:
            self = networkError
        case let urlError as URLError:
            self = .init(urlError.code.rawValue)
        default:
            self = .unmapped(error.localizedDescription)
        }
    }
}

public struct ResponseError: Decodable, Equatable {
    public let message: String
    public let documentation_url: String
}
