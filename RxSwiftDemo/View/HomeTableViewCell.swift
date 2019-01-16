//
//  HomeTableViewCell.swift
//  RxSwiftDemo
//
//  Created by 張帥 on 2018/12/10.
//  Copyright © 2018 張帥. All rights reserved.
//

import RxSwift
import RxCocoa
import SnapKit

class HomeTableViewCell: BaseTableViewCell {
    
    lazy var model = BehaviorRelay(value: Repository())
    
    lazy var titleLab: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var detailLab: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    lazy var contentLab: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    lazy var actionBtn: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.borderWidth = 1
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return button
    }()
    
    var isButtonActive: Bool = false {
        willSet {
            switch newValue {
            case true:
                actionBtn.setTitle("Unsubscribe", for: .normal)
            case false:
                actionBtn.setTitle("Subscribe", for: .normal)
            }
        }
    }
    
    override func buildSubViews() {
        contentView.addSubview(titleLab)
        contentView.addSubview(detailLab)
        contentView.addSubview(contentLab)
        contentView.addSubview(actionBtn)
    }
    
    override func makeConstraints() {
        titleLab.snp.makeConstraints { (make) in
            make.top.left.equalTo(UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
            make.right.lessThanOrEqualTo(actionBtn.snp.left).offset(10)
        }
        
        detailLab.snp.makeConstraints { (make) in
            make.top.equalTo(titleLab.snp.bottom).offset(20)
            make.left.right.equalTo(UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
        }
        
        contentLab.snp.makeConstraints { (make) in
            make.top.equalTo(detailLab.snp.bottom).offset(20)
            make.bottom.left.right.equalTo(UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
        }
        
        actionBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLab)
            make.top.right.equalTo(UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
            make.size.equalTo(CGSize(width: 90, height: 25))
        }
    }
    
    override func bindViewModel() {
        model.bind {
            [weak self] in guard let `self` = self else { return }
            self.titleLab.text = $0.name
            self.detailLab.text = $0.desp
            self.contentLab.text = $0.htmlUrl
            self.isButtonActive = $0.isSubscribed
            print("\($0.isSubscribed ? "#" : "") \($0.name)", tag: "SubscriptionDebug")
        }
        .disposed(by: disposeBag)
        
        actionBtn.rx.tap
            .asObservable()
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: {
                [weak self] in guard let `self` = self else { return }
                self.isButtonActive.toggle()
                self.model.value.isSubscribed = self.isButtonActive
                self.isButtonActive
                    ? DataBaseAPI.shared.add(repository: self.model.value)
                    : DataBaseAPI.shared.delete(repository: self.model.value)
            })
            .disposed(by: disposeBag)
    }
}

