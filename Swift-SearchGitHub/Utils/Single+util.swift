//
//  Single+util.swift
//  Swift-SearchGitHub
//
//  Created by AndyChen on 2021/3/17.
//

import Foundation
import RxSwift
import RxCocoa

extension PrimitiveSequence where TraitType == SingleTrait {
  public func subscribeSuccess(_ callback:((ElementType) -> Void)? = nil) -> Disposable {
    return subscribe(onSuccess: callback, onError: { error in
        ErrorHandler.show(error: error)
    })
  }
}

extension PrimitiveSequence {
    /// 觸發在主線程
    func observeOnMain() -> PrimitiveSequence<Trait, Element> {
        return observeOn(MainScheduler.instance)
    }
}
