//
//  ErrorHandler.swift
//  Swift-SearchGitHub
//
//  Created by AndyChen on 2021/3/17.
//

import Foundation
import Toaster
import RxSwift
import RxCocoa

import Foundation
import Toaster
class ErrorHandler {
    
    static func show(error:Error) {
        if let error = error as? ApiServiceError {
            switch error {
            case .domainError(let msgOne,let msgTwo):
                if let mOne = msgOne,let mTwo = msgTwo
                {
                    print("allMsg : \(mOne) \(mTwo)")
                    showAlert(title: "domainError", message: "\(mOne) \(mTwo)")
                }
            case .networkError(let msg):
                print(msg ?? " no error message")
                showAlert(title: "networkError", message: msg ?? "")
            case .unknownError(let msg):
                print(msg ?? " no error message")
                showAlert(title: "unknownError", message: msg ?? "")
            }
        } else {
            Toast.show(msg:"unDefine error type")
        }
        
    }
    
    static func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "確定", style: .default, handler: nil)
        alert.addAction(okAction)
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
    
}
