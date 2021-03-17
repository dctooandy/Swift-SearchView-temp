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
    func searchKeywords(keywords:String) -> Single<[UserResultDto]?>
    {
        var parameters: Parameters = [String: Any]()
        parameters = ["q":keywords]
        return Beans.requestServer.singleRequestGet(
            path: ApiService.search("users").path,
            parameters: parameters,
            resultType: UserResultDto.self).map({
                return $0.items
            })
    }
}
