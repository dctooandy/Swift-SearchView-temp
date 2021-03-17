//
//  ResponseDto.swift
//  Swift-SearchGitHub
//
//  Created by AndyChen on 2021/3/17.
//

import Foundation
class ResponseDto<T:Codable>:Codable
{
    let total_count:JSONValue?
    let incomplete_results:JSONValue?
    let items :[T]?
    init(total_count:JSONValue = JSONValue.int(0),
         incomplete_results:JSONValue = JSONValue.bool(false),
         items : [T]
    ){
        self.total_count = total_count
        self.incomplete_results = incomplete_results
        self.items = items
    }
}


