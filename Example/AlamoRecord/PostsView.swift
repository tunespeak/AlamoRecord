//
//  PostsView.swift
//  AlamoRecord
//
//  Created by Dalton Hinterscher on 7/6/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import SnapKit
import UIKit

protocol PostsViewDelegate: class {
    func numberOfPosts() -> Int
    func post(at index: Int) -> Post
    func commentsButtonPressed(at index: Int)
    func destroyButtonPressed(at index: Int)
}

class PostsView: UIView {

    fileprivate weak var delegate: PostsViewDelegate?
    private(set) var tableView: UITableView!
    
    init(delegate: PostsViewDelegate) {
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

extension PostsView: UITableViewDataSource {
    
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate!.numberOfPosts()
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: PostCell? = tableView.dequeueReusableCell(withIdentifier: PostCell.reuseIdentifier) as? PostCell
        
        if cell == nil {
            cell = PostCell()
            cell?.delegate = self
        }
        
        cell?.bind(post: delegate!.post(at: indexPath.row))
        return cell!
    }
}

extension PostsView: UITableViewDelegate {
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension PostsView: PostCellDelegate {
    
    internal func commentsButtonPressed(at index: Int) {
        delegate?.commentsButtonPressed(at: index)
    }
    
    internal func destroyButtonPressed(at index: Int) {
        delegate?.destroyButtonPressed(at: index)
    }
}
