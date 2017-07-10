//
//  PostCell.swift
//  AlamoRecord
//
//  Created by Dalton Hinterscher on 7/6/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

protocol PostCellDelegate: class {
    func commentsButtonPressed(at index: Int)
    func destroyButtonPressed(at index: Int)
}

import UIKit

class PostCell: BaseTableViewCell {

    weak var delegate: PostCellDelegate?
    private var titleLabel: UILabel!
    private var bodyLabel: UILabel!
    
    required init() {
        super.init()
        selectionStyle = .none
        
        titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize * 1.25)
        resizableView.addSubview(titleLabel)
        
        bodyLabel = UILabel()
        bodyLabel.numberOfLines = 0
        bodyLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        resizableView.addSubview(bodyLabel)
        
        let footerView = UIView()
        footerView.backgroundColor = resizableView.backgroundColor
        resizableView.addSubview(footerView)
        
        let footerViewTopBorderView = UIView()
        footerViewTopBorderView.backgroundColor = .lightGray
        footerView.addSubview(footerViewTopBorderView)
        
        let commentsButton = UIButton()
        commentsButton.setTitle("COMMENTS", for: .normal)
        commentsButton.setTitleColor(.blue, for: .normal)
        commentsButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        commentsButton.addTarget(self, action: #selector(commentsButtonPressed), for: .touchUpInside)
        footerView.addSubview(commentsButton)
        
        let seperatorView = UIView()
        seperatorView.backgroundColor = footerViewTopBorderView.backgroundColor
        footerView.addSubview(seperatorView)
        
        let destroyButton = UIButton()
        destroyButton.setTitle("DESTROY", for: .normal)
        destroyButton.setTitleColor(.red, for: .normal)
        destroyButton.titleLabel?.font = commentsButton.titleLabel?.font
        destroyButton.addTarget(self, action: #selector(destroyButtonPressed), for: .touchUpInside)
        footerView.addSubview(destroyButton)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        bodyLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.equalTo(titleLabel)
            make.right.equalTo(titleLabel)
        }
        
        footerView.snp.makeConstraints { (make) in
            make.top.equalTo(bodyLabel.snp.bottom).offset(20)
            make.left.equalTo(titleLabel)
            make.right.equalTo(titleLabel)
            make.height.equalTo(35)
        }
        
        footerViewTopBorderView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        commentsButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalToSuperview()
        }
        
        seperatorView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(footerViewTopBorderView.snp.height)
            make.centerX.equalToSuperview()
        }
        
        destroyButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalToSuperview()
        }
        
        autoResize(under: footerView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(post: Post) {
        titleLabel.text = post.title
        bodyLabel.text = post.body
    }
    
    private dynamic func commentsButtonPressed() {
        delegate?.commentsButtonPressed(at: indexPath.row)
    }
    
    private dynamic func destroyButtonPressed() {
        delegate?.destroyButtonPressed(at: indexPath.row)
    }
}
