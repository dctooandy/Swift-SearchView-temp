//
//  SearchBarView.swift
//  Swift-SearchGitHub
//
//  Created by AndyChen on 2021/3/17.
//

import UIKit
import RxSwift
import RxCocoa

protocol SearchBarViewCellDelegate: class {
    func searchBarTextDidChange(text: String)
    func searchBarSearchButtonClicked()
    func searchBarCancelButtonClicked()
}

class SearchBarView: UIView {
    let disposeBag = DisposeBag()
    weak var delegate: SearchBarViewCellDelegate?
    var searchBar: UISearchBar = {
        let view = UISearchBar()
        return view
    }()
    init() {
        super.init(frame: .zero)
        bind()
        setupViewUI()
    }
 
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupViewUI() {
        self.backgroundColor = #colorLiteral(red: 0.8901960784, green: 0.9921568627, blue: 0.9921568627, alpha: 1)
        self.addSubview(searchBar)
        searchBar.textField?.textColor = .white
        searchBar.placeholder = "請輸入您要搜尋的ID"
        searchBar.layer.cornerRadius = pWidth(20)
        searchBar.textField?.backgroundColor = #colorLiteral(red: 0.4431372549, green: 0.7882352941, blue: 0.8078431373, alpha: 1)
        searchBar.barTintColor = #colorLiteral(red: 0.4431372549, green: 0.7882352941, blue: 0.8078431373, alpha: 1)
        searchBar.layer.masksToBounds = true
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        }
        searchBar.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(pWidth(10))
            maker.left.equalToSuperview().offset(pWidth(10))
            maker.right.equalToSuperview().offset(-pWidth(10))
            maker.bottom.equalToSuperview().offset(-pWidth(5))
        }
    }
    private enum Status {
        case setQuery(String)
        case cancel
        case done
        case end
        case start
    }
    func bind()
    {
        searchBar
            .rx.text
            .orEmpty.map{ $0.replacingOccurrences(of: " ", with: "") }
            .subscribeSuccess { str in
                self.searchBarChangeStatus(to: .setQuery(str))
            }.disposed(by: disposeBag)
        searchBar.rx
            .cancelButtonClicked
            .subscribeSuccess { _ in
                self.searchBarChangeStatus(to: .cancel)
            }.disposed(by: disposeBag)
        
        searchBar.rx
            .searchButtonClicked
            .subscribeSuccess { _ in
                self.searchBarChangeStatus(to: .done)
            }.disposed(by: disposeBag)
        
        searchBar.rx
            .textDidBeginEditing
            .subscribeSuccess { _ in
                self.searchBarChangeStatus(to: .start)
            }.disposed(by: disposeBag)
        
        searchBar.rx
            .textDidEndEditing
            .subscribeSuccess { _ in
                self.searchBarChangeStatus(to: .end)
            }.disposed(by: disposeBag)
    }
}
extension SearchBarView
{
    
    private func searchBarChangeStatus(to status: Status) {
        switch status {
        case .setQuery(let str):
            print("query: \(str)")
            self.searchBar.text = str
            self.delegate?.searchBarTextDidChange(text: str)
        case .done:
            print("searchBar click done")
            self.searchBar.endEditing(true)
            self.searchBar.showsCancelButton = false
            self.delegate?.searchBarSearchButtonClicked()
        case .cancel:
            print("searchBar click cancel")
            self.searchBar.text = ""
            self.searchBar.endEditing(true)
            self.searchBar.showsCancelButton = false
            self.delegate?.searchBarCancelButtonClicked()
        case .start:
            print("searchBar textDidBeginEditing.")
            self.searchBar.showsCancelButton = true
        case .end:
            print("searchBar textDidEndEditing.")
        }
    }
}
