//
//  RequestService.swift
//  Swift-SearchGitHub
//
//  Created by AndyChen on 2021/3/17.
//

import Foundation
import Alamofire
import RxCocoa
import RxSwift
import Toaster

class RequestService {
    
    private lazy var sessionManager:SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 6
        let manger = SessionManager(configuration: configuration)
        manger.adapter = AccessTokenAdapter()
        
        return manger
    }()
}
extension RequestService
{
    func singleRequestDelete<T:Codable>(path:URL?,
                                       parameters:Parameters? = nil,
                                       modify:Bool = true,
                                       resultType:T.Type,
                                       encoding: ParameterEncoding = URLEncoding.default) -> Single<ResponseDto<T>> {
        return singleRequest(path: path, parameters:parameters , modify: modify , resultType: resultType, method: .delete,encoding: encoding)
    }
    func singleRequestPatch<T:Codable>(path:URL?,
                                      parameters:Parameters? = nil,
                                      modify:Bool = true,
                                      resultType:T.Type,
                                      encoding: ParameterEncoding = URLEncoding.default) -> Single<ResponseDto<T>> {
        return singleRequest(path: path, parameters:parameters , modify: modify , resultType: resultType, method: .patch,encoding: encoding)
    }
    func singleRequestPost<T:Codable>(path:URL?,
                                          parameters:Parameters? = nil,
                                          modify:Bool = true,
                                          resultType:T.Type,
                                          encoding: ParameterEncoding = URLEncoding.default) -> Single<ResponseDto<T>> {
        return singleRequest(path: path, parameters:parameters , modify: modify , resultType: resultType, method: .post,encoding: encoding)
    }
    func singleRequestGet<T:Codable>(path:URL?,
                                         parameters:Parameters? = nil,
                                         modify:Bool = true,
                                         resultType:T.Type,
                                         encoding: ParameterEncoding = URLEncoding.default) -> Single<ResponseDto<T>> {
        return singleRequest(path: path, parameters:parameters , modify: modify , resultType: resultType, method: .get,encoding: encoding)
    }
    func singleRequestPut<T:Codable>(path:URL?,
                                          parameters:Parameters? = nil,
                                          modify:Bool = true,
                                          resultType:T.Type,
                                          encoding: ParameterEncoding = URLEncoding.default) -> Single<ResponseDto<T>> {
        return singleRequest(path: path, parameters:parameters  , modify: modify , resultType: resultType, method: .put,encoding: encoding)
    }
    func singleRequest<T:Codable>(path:URL?,
                                  parameters:Parameters? = nil,
                                  modify:Bool = true,
                                  resultType:T.Type,
                                  method:HTTPMethod,
                                  encoding: ParameterEncoding = URLEncoding.default) -> Single<ResponseDto<T>>
    {
        guard let url = path else {
            Log.errorAndCrash(ApiServiceError.unknownError("url 解析錯誤"))
        }
        
        Log.v("API URL: \(path!)\n=====================\nMethod: \(method)\n=====================\n參數: \(parameters ?? Parameters())")
        return Single<ResponseDto<T>>.create { observer in
            let task = self.sessionManager
                .request(url,
                         method: method,
                         parameters: parameters,
                         encoding: encoding)
                .responseCustomModel(T.self,
                                     onData:{ (result:ResponseDto<T>) in
                                        observer(.success(result)) },
                                     onError:{ (error:ApiServiceError) in
                                        observer(.error(error))})
            
            task.resume()
            return Disposables.create { task.cancel() }
        }
    }
}
