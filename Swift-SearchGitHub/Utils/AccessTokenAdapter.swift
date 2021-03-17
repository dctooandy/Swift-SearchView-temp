//
//  AccessTokenAdapter.swift
//  Swift-SearchGitHub
//
//  Created by AndyChen on 2021/3/17.
//

import Foundation
import Alamofire

class AccessTokenAdapter: RequestAdapter {

    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {

        var urlRequest = urlRequest
        var contentString = ""
  
        if let urlString = urlRequest.url
        {
            if urlString.lastPathComponent.contains("users")
            {
                urlRequest.setValue("application/vnd.github.v3+json", forHTTPHeaderField:"Accept")
                contentString = "application/x-www-form-urlencoded"
            }
            urlRequest.setValue(contentString, forHTTPHeaderField: "Content-Type")
        }
        return urlRequest
    }
}
