//
//  GithubEndpoint.swift
//  AppCore
//
//  Created by Tassio Marques on 17/02/25.
//

import Foundation
import NetworkingInterface

enum RepositoriesEndpoint: NetworkEndpoint {
    case searchRepositories(language: String, page: Int, perPage: Int)
    case fetchPullRequests(repositoryFullName: String)
    
    var scheme: String { "https" }
    
    var baseURL: String {
        API.GITHUB.baseURL
    }
    
    var path: String {
        switch self {
        case .searchRepositories:
            return "/search/repositories"
        case .fetchPullRequests(let repositoryFullName):
            return "/repos/\(repositoryFullName)/pulls"
        }
    }
    
    var method: NetworkingInterface.HTTPMethod {
        switch self {
        case .searchRepositories, .fetchPullRequests:
            return .get
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case let .searchRepositories(language, page, perPage):
            return [
                URLQueryItem(name: "q", value: "language:\(language)"),
                URLQueryItem(name: "sort", value: "stars"),
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "per_page", value: String(perPage))
            ]
        default:
            return nil
        }
    }
}

extension RepositoriesEndpoint {
    func buildRequest() -> URLRequest? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = baseURL
        components.path = path
        components.queryItems = queryItems
        let url = components.url

        guard let url = url else {
            return nil
        }

        return URLRequest(url: url)
    }
}
