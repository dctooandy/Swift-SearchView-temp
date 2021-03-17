//
//  DataView.swift
//  Swift-SearchGitHub
//
//  Created by AndyChen on 2021/3/17.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher
import Lottie

class DataView: UIView
{
    var avatorImageView : UIImageView = {
        let img = UIImageView(image: UIImage())
        img.backgroundColor = .clear
        return img
    }()
    let iconLoadingView: AnimationView = {
        let view = AnimationView(name:"circles-menu-1")
        view.loopMode = LottieLoopMode.loop
        view.animationSpeed = 2
        return view
    }()
    var nameLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        setupViewUI()
    }
 
    func configForDataView(color:UIColor , imgURL:String , nameString:String ,viewWidth:CGFloat)
    {
        playLoadIngAnimation()
        self.backgroundColor = color
        avatorImageView.setImage(with: URL(string: imgURL)) {
            self.stopLoadIngAnimation()
        }
        nameLabel.text = nameString
        avatorImageView.applyCornerRadius(radius: viewWidth * 0.3 / 2)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func playLoadIngAnimation()
    {
        if !iconLoadingView.isAnimationPlaying
        {
            iconLoadingView.isHidden = false
            iconLoadingView.play()
        }
    }
    func stopLoadIngAnimation()
    {
        iconLoadingView.isHidden = true
        iconLoadingView.stop()
    }
    func setupViewUI() {
        self.backgroundColor = #colorLiteral(red: 0.6509803922, green: 0.8901960784, blue: 0.9137254902, alpha: 1)
        self.layer.cornerRadius = pWidth(20)
        self.layer.masksToBounds = true
        self.addSubview(avatorImageView)
        avatorImageView.snp.makeConstraints { (maker) in
            maker.centerY.equalToSuperview()
            maker.width.equalToSuperview().multipliedBy(0.3)
            maker.height.equalTo(avatorImageView.snp.width)
            maker.left.equalToSuperview().offset(pWidth(20))
        }
        
        avatorImageView.addSubview(iconLoadingView)
        iconLoadingView.snp.makeConstraints { (maker) in
            maker.size.equalTo(pWidth(40))
            maker.center.equalToSuperview()
        }
        
        self.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(avatorImageView.snp.right).offset(pWidth(10))
            maker.right.equalToSuperview().offset(pWidth(-5))
            maker.centerY.height.equalTo(avatorImageView)
        }
    }
    override func layoutSubviews() {
        
    }
}
