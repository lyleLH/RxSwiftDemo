//
//  RepositoryViewController.swift
//  RxSwiftDemo
//
//  Created by 張帥 on 2018/12/13.
//  Copyright © 2018 張帥. All rights reserved.
//

import UIKit

class OwnerViewController: BaseViewController {
    
    lazy var mainView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var iconImg: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    lazy var titleLab: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var detailLab: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    var owner: RepositoryOwner?
    
    override func buildSubViews() {
        view.addSubview(mainView)
        mainView.addSubview(iconImg)
        mainView.addSubview(titleLab)
        mainView.addSubview(detailLab)
    }

    override func makeConstraints() {
        mainView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.top.left.greaterThanOrEqualToSuperview()
            make.bottom.right.lessThanOrEqualToSuperview()
        }
        
        iconImg.snp.makeConstraints { (make) in
            make.top.left.equalTo(UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        titleLab.snp.makeConstraints { (make) in
            make.top.equalTo(UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
            make.right.lessThanOrEqualToSuperview().offset(-20)
            make.left.equalTo(iconImg.snp.right).offset(20)
            make.centerY.equalTo(iconImg)
        }
        
        detailLab.snp.makeConstraints { (make) in
            make.top.equalTo(iconImg.snp.bottom).offset(20)
            make.bottom.left.right.equalTo(UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
        }
    }
    
    override func bindViewModel() {
        guard let owner = owner else { return }
        
        iconImg.sd_setImage(with: URL(string: owner.avatarUrl))
        titleLab.text = owner.login
        detailLab.text = owner.url
    }
}