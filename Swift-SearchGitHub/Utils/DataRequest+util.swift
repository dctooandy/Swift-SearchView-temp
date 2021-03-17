//
//  DataRequest+util.swift
//  Swift-SearchGitHub
//
//  Created by AndyChen on 2021/3/17.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import Toaster

extension DataRequest
{
    func responseCustomModel<T:Codable>(_ type:T.Type,
                                        onData:((ResponseDto<T>) -> Void)? = nil,
                                        onError:((ApiServiceError) -> Void)? = nil) -> Self {
        return responseJSON { response in
            let requestPath = response.request?.url?.path ?? ""
//            let requestQuery = response.request?.url?.query
            let requestURLString = requestPath
    
            // 驗證是否有回傳資料
            guard let data = response.data else { Log.errorAndCrash("response no data") }
            // 開始解密
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .millisecondsSince1970
            var errorMsg = ""
            var apiError : ApiServiceError!
            if let statusCode = response.response?.statusCode {
                switch statusCode
                {
                case 200..<400:
                    do {
                        // 驗證是否 ret 200
                        if let responseString = String(data: data, encoding: .utf8),
                            let dict = self.convertToDictionary(urlString:requestURLString , text: responseString)
                        {
                            Log.v("Response API: \(requestURLString)\n回傳值\nresponse dict keys: \(dict as AnyObject)")
                            let results = try decoder.decode(ResponseDto<T>.self, from:data)
                            onData?(results)
                            
                        }else
                        {
                            errorMsg = "無法解析資料"
                            apiError = ApiServiceError.unknownError(errorMsg)
                            onError?(apiError)
                        }
                    }
                    catch DecodingError.dataCorrupted(_) {
                        errorMsg = "伺服器繁忙，请稍候再试"
                        apiError = ApiServiceError.unknownError(errorMsg)
                        onError?(apiError)
                    }
                    catch DecodingError.keyNotFound(let key, let context) {
                        apiError = ApiServiceError.unknownError("\(context.debugDescription) , \(requestURLString) , \(key)")
                        onError?(apiError)
                    }
                    catch DecodingError.typeMismatch(let type, let context) {
                        apiError = ApiServiceError.unknownError("\(context.debugDescription) , \(requestURLString) , \(type)")
                        onError?(apiError)
                    }
                    catch DecodingError.valueNotFound(let value, let context) {
                        apiError = ApiServiceError.unknownError("\(context.debugDescription) , \(requestURLString) , \(value)")
                        onError?(apiError)
                    }
                    catch {
                        errorMsg = error.localizedDescription
                        Log.e(errorMsg)
                        apiError = ApiServiceError.unknownError(errorMsg)
                        onError?(apiError)
                    }
             
                default:
                    errorMsg = "網路發生錯誤，請稍後再試"
                    apiError = ApiServiceError.unknownError(errorMsg)
                    onError?(apiError)
                }
            }
            else
            {
                errorMsg = "參數錯誤"
                apiError = ApiServiceError.unknownError(errorMsg)
                onError?(apiError)
            }
        }
    }
    
    func convertToDictionary(urlString : String = "" , text: String) -> [String: Any]?
    {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
            }
        }
        return nil
    }
}

