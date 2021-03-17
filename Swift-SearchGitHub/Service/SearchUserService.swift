//
//  SearchUserService.swift
//  Swift-SearchGitHub
//
//  Created by AndyChen on 2021/3/17.
//

import Foundation

import RxCocoa
import RxSwift
import Alamofire

class SearchUserService {
    func searchKeywords(keywords:String, page: Int) -> Single<[UserResultDto]?>
    {
        var parameters: Parameters = [String: Any]()
        parameters = ["q":keywords , "page" : page, "per_page": 5]
        return Beans.requestServer.singleRequestGet(
            path: ApiService.search("users").path,
            parameters: parameters,
            resultType: UserResultDto.self).map({
                return $0.items
            })
    }
}
