//
//  SearchCollectionViewCell.swift
//  Swift-SearchGitHub
//
//  Created by AndyChen on 2021/3/17.
//

import UIKit
import SnapKit

class SearchCollectionViewCell: UICollectionViewCell {
    var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        return view
    }()
    override var isSelected: Bool{
        didSet{}
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUpUI()
    {
        contentView.backgroundColor = .clear
        self.layer.cornerRadius = pWidth(20)
        self.layer.masksToBounds = true
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
    }
    override func setNeedsLayout() {
        setUpUI()
    }
    func config(data:CellSizeMode)
    {
        switch data {
        case .helfHelf:

            print("helfHelf contentView : \(contentView.frame) \ndata.cellSize : \(data.cellSize)" )
        case .quarterHelf:
            print("quarterHelf contentView : \(contentView.frame) \ndata.cellSize : \(data.cellSize)" )
        case .quarterQuarter:
            print("quarterQuarter contentView : \(contentView.frame) \ndata.cellSize : \(data.cellSize)" )

        }
    }
}
