//
//  SearchViewController.swift
//  Swift-SearchGitHub
//
//  Created by AndyChen on 2021/3/17.
//

import Foundation
import UIKit

class SearchViewController: BaseViewController, SearchBarViewCellDelegate {
    var viewModel = SearchViewModel()
    
    // 最上面的SearchBar
    var searchBarView : SearchBarView = {
        let view = SearchBarView()
        return view
    }()
    var searchKeyWords : String = ""
    // 下面的 TableView
    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "SearchTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        return tableView
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.8901960784, green: 0.9921568627, blue: 0.9921568627, alpha: 1)
        viewModel.randomArray()
        setUpUI()
        bindModel()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func setUpUI()
    {
        self.view.addSubview(searchBarView)
        searchBarView.delegate = self
        searchBarView.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(Views.statusBarHeight)
            maker.left.right.equalToSuperview()
            maker.height.equalTo(Views.screenHeight*0.1)
        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (maker) in
            maker.top.equalTo(searchBarView.snp.bottom).offset(pWidth(5))
            maker.left.right.equalToSuperview()
            maker.bottom.equalToSuperview().offset(-Views.bottomOffset)
        }
    }
    func reloadDataSetion() {
        viewModel.randomArray()
        UIView.animate(withDuration: 0.25) {
            self.tableView.alpha = 0
        } completion: { (_) in
            self.tableView.reloadData()
            UIView.animate(withDuration: 0.25) {
                self.tableView.alpha = 1
            }
        }
    }
    func bindModel()
    {
        viewModel.rxSearchSuccessData().subscribeSuccess { [weak self](_) in
            self?.reloadDataSetion()
        }.disposed(by: disposeBag)
    }
}
extension SearchViewController
{
    func searchBarTextDidChange(text: String) {
        print("search text: \(text)")
        if text.isEmpty {
            
        } else {
            searchKeyWords = text
        }
    }
    
    func searchBarSearchButtonClicked() {
        print("searchBarSearchButtonClicked")
        viewModel.deleteAllData()
        viewModel.searchText(keyWords: searchKeyWords)
    }
    
    func searchBarCancelButtonClicked() {
        print("searchBarCancelButtonClicked")
        viewModel.deleteAllData()
        reloadDataSetion()
    }
}

extension SearchViewController : UITableViewDelegate , UITableViewDataSource , UIScrollViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sizeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        cell.config(data: viewModel.sizeArray[indexPath.row].sizeMode,
                    usersData:viewModel.sizeArray[indexPath.row].userData)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.sizeArray[indexPath.row].sizeMode.cellSize.height
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard scrollView.contentSize.height > tableView.frame.height else {return}
        if scrollView.contentSize.height - (scrollView.frame.size.height + scrollView.contentOffset.y) <= -10 && viewModel.isNeedLoadMore{
            print("Pull up to load more")
            viewModel.currentPage += 1
            viewModel.searchText(keyWords: searchKeyWords)
        }
    }
}
