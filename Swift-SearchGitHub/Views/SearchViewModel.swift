//
//  SearchViewModel.swift
//  Swift-SearchGitHub
//
//  Created by AndyChen on 2021/3/17.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit
// size 選擇
enum CellSizeMode:Int, CaseIterable {
    case helfHelf = 1
    case quarterHelf
    case quarterQuarter
    
    var cellSize: CGSize {
        var size = CGSize(width: Views.screenWidth - pWidth(20), height: 0)
        let defaultTopHeight = Views.screenHeight - pWidth(15) - Views.statusBarHeight - (Views.screenHeight*0.1) - pWidth(20) - Views.bottomOffset
        switch self {
        case .helfHelf:
            size.height = defaultTopHeight * 0.5
        case .quarterHelf:
            size.height = defaultTopHeight * 0.25
        case .quarterQuarter:
            size.height = defaultTopHeight * 0.25
        }
        return size
    }
    var cellBGColor: UIColor {
        switch self {
        case .helfHelf:
            return #colorLiteral(red: 0.7960784314, green: 0.9450980392, blue: 0.9607843137, alpha: 1)
        case .quarterHelf:
            return #colorLiteral(red: 0.7960784314, green: 0.9450980392, blue: 0.9607843137, alpha: 1)
        case .quarterQuarter:
            return #colorLiteral(red: 0.6509803922, green: 0.8901960784, blue: 0.9137254902, alpha: 1)
        }
    }
}
class SearchViewModel: BaseViewModel {
    private var searchSuccessData = PublishSubject<Void>()
    var currentPage: Int = 1
    var isNeedLoadMore: Bool = false
    var usersDataArray :[UserResultDto] = []
    var nextPageUsersDataArray :[UserResultDto] = []
    var allSizeMode : [CellSizeMode] = [.helfHelf, .quarterHelf, .quarterQuarter]
    var sizeArray : [(sizeMode:CellSizeMode ,userData:UserResultDto )] = []
    override init() {
        super.init()
        self.bind()
    }
    func bind() {
        
    }
    
    func randomArray()
    {
        allSizeMode.shuffle()
    }
    func deleteAllData()
    {
        currentPage = 1
        nextPageUsersDataArray.removeAll()
        usersDataArray.removeAll()
        sizeArray.removeAll()
    }
    func searchText(keyWords:String)
    {
        Beans.searchServer.searchKeywords(keywords: keyWords ,page: currentPage).subscribeSuccess { [weak self](dto) in
            
            if let data = dto
            {
                self?.isNeedLoadMore = !data.isEmpty
                if self?.currentPage == 1{
                    self?.usersDataArray = data
                    self?.injectDataToArray()
                }else{
                    self?.nextPageUsersDataArray.removeAll()
                    if self?.isNeedLoadMore == true
                    {
                        self?.nextPageUsersDataArray = data
                        self?.injectDataToArray()
                    }
                }
                self?.searchSuccessData.onNext(())
                
            }
         }.disposed(by: disposeBag)
    }
    
    func injectDataToArray()
    {
        if nextPageUsersDataArray.count > 0
        {
            swipeData(currentData: nextPageUsersDataArray)
            usersDataArray += nextPageUsersDataArray
        }else
        {
            swipeData(currentData: usersDataArray)
        }
    }
    func swipeData(currentData:[UserResultDto] ){
        for data in currentData {
            if let size = allSizeMode.randomElement()
            {
                sizeArray.append((sizeMode:size , userData: data))
            }
        }
    }
}
extension SearchViewModel
{
    func rxSearchSuccessData() -> Observable<Void>
    {
        return self.searchSuccessData.asObserver()
    }
}
