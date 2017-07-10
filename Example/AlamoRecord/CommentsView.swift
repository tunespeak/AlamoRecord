//
//  CommentsView.swift
//  AlamoRecord
//
//  Created by Dalton Hinterscher on 7/7/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

protocol CommentsViewDelegate: class {
    func numberOfComments() -> Int
    func comment(at index: Int) -> Comment
}

class CommentsView: UIView {

    fileprivate weak var delegate: CommentsViewDelegate?
    private(set) var tableView: UITableView!
    
    init(delegate: CommentsViewDelegate) {
        super.init(frame: .zero)
        self.backgroundColor = .white
        self.delegate = delegate
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .darkWhite
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50.0
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0)
        addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CommentsView: UITableViewDataSource {
    
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate!.numberOfComments()
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: CommentCell? = tableView.dequeueReusableCell(withIdentifier: CommentCell.reuseIdentifier) as? CommentCell
        
        if cell == nil {
            cell = CommentCell()
        }
        
        cell?.bind(comment: delegate!.comment(at: indexPath.row))
        return cell!
    }
}

extension CommentsView: UITableViewDelegate {
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
