//
//  ApiService.swift
//  Swift-SearchGitHub
//
//  Created by AndyChen on 2021/3/17.
//

import Foundation

enum ApiServiceError:Error {
    case networkError(String?)
    case domainError(String?,String?)
    case unknownError(String?)
}

enum ApiService {
    static let host = "https://api.github.com/"

    case search(String)
    
    var path:URL? {
        switch self {
        case .search(let endpoint):
            return URL(string:ApiService.host + "search/\(endpoint)")
        }
    }
}



