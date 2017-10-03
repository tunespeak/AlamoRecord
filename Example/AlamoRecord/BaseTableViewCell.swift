//
//  BaseTableViewCell.swift
//  AlamoRecord
//
//  Created by Dalton Hinterscher on 7/6/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    
    class var reuseIdentifier: String {
        return NSStringFromClass(self)
    }
    
    internal var tableView: UITableView {
        var view = superview
        while view != nil {
            if let tableView = view as? UITableView {
                return tableView
            }
            view = view?.superview
        }
        fatalError("tableView was not found for instance of BaseTableViewCell")
    }
    
    internal var indexPath: IndexPath {
        return tableView.indexPathForRow(at: center)!
    }
    
    internal var resizableView: UIView!
    
    required init() {
        super.init(style: .default, reuseIdentifier: type(of: self).reuseIdentifier)
        contentView.backgroundColor = .darkWhite
        
        resizableView = UIView()
        resizableView.backgroundColor = .white
        contentView.addSubview(resizableView)
        
        resizableView.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview()
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func autoResize(under bottomView: UIView) {
        resizableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalTo(bottomView).offset(10)
        }
    }

}
