//
//  SearchTableViewCell.swift
//  Swift-SearchGitHub
//
//  Created by AndyChen on 2021/3/17.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

class SearchTableViewCell: UITableViewCell {
    var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    var firstDataView : DataView = {
        let view = DataView()
        return view
    }()
    var secondDataView : DataView = {
        let view = DataView()
        view.isHidden = true
        return view
    }()
    private var filterStackView = UIStackView()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setUpUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUpUI()
    {
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear

        contentView.addSubview(bgView)
        bgView.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(pWidth(5))
            maker.bottom.equalToSuperview().offset(-pWidth(5))
            maker.left.equalToSuperview().offset(pWidth(10))
            maker.right.equalToSuperview().offset(-pWidth(10))
        }
        filterStackView = UIStackView(arrangedSubviews: [firstDataView, secondDataView])
        filterStackView.alignment = .fill
        filterStackView.distribution = .fillEqually
        filterStackView.axis = .horizontal
        filterStackView.spacing = pWidth(10)
        filterStackView.backgroundColor = .clear
        
        bgView.addSubview(filterStackView)

        filterStackView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
    }
    func bind()
    {
        
    }
    func config(data:CellSizeMode , usersData:[UserResultDto])
    {
        if let firstUsersData = usersData.first,
            let avatorUrl = firstUsersData.avatar_url,
           let nameString = firstUsersData.login
        {
            var viewWidth = Views.screenWidth - pWidth(20)
            switch data {
            case .helfHelf:
                secondDataView.isHidden = true
            case .quarterHelf:
                secondDataView.isHidden = true
            case .quarterQuarter:
                viewWidth /= 2
                secondDataView.isHidden = false
            }
            firstDataView.configForDataView(color: data.cellBGColor, imgURL: avatorUrl, nameString: nameString ,viewWidth : viewWidth)
            if data == .quarterQuarter ,
               usersData.count > 1,
               let lastUsersData = usersData.last,
               let avatorUrl = lastUsersData.avatar_url,
              let nameString = lastUsersData.login
            {
                secondDataView.configForDataView(color: data.cellBGColor, imgURL: avatorUrl, nameString: nameString ,viewWidth : viewWidth)
            }else
            {
                secondDataView.stopLoadIngAnimation()
            }
        }
    }
}
