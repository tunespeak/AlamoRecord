//
//  PostsViewController.swift
//  AlamoRecord
//
//  Created by Dalton Hinterscher on 7/6/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import NotificationBannerSwift
import UIKit

class PostsViewController: UIViewController {

    fileprivate var model: PostsModel = PostsModel()
    fileprivate var postsView: PostsView {
        return view as! PostsView
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        edgesForExtendedLayout = UIRectEdge()
        view = PostsView(delegate: self)
        title = Post.pluralRoot.capitalized
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "CREATE", style: .plain, target: self, action: #selector(onCreatePostButtonPressed))
        
        model.getAll(success: {
            self.postsView.tableView.reloadData()
        }) { (error) in
            print(error)
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private dynamic func onCreatePostButtonPressed() {
        let createController = CreatePostViewController(delegate: self)
        navigationController?.pushViewController(createController, animated: true)
    }
}

extension PostsViewController: PostsViewDelegate {
    
    internal func numberOfPosts() -> Int {
        return model.numberOfPosts()
    }
    
    internal func post(at index: Int) -> Post {
        return model.post(at: index)
    }
    
    internal func commentsButtonPressed(at index: Int) {
        let commentsModel = CommentsModel(post: post(at: index))
        let commentsController = CommentsViewController(model: commentsModel)
        navigationController?.pushViewController(commentsController, animated: true)
    }
    
    internal func destroyButtonPressed(at index: Int) {
        model.destroyPost(at: index, success: {
            let indexPath = IndexPath(row: index, section: 0)
            self.postsView.tableView.deleteRows(at: [indexPath], with: .automatic)
            let banner = StatusBarNotificationBanner(title: "Post destroyed.", style: .success)
            banner.duration = 1.0
            banner.show()
        }) { (error) in
            let banner = StatusBarNotificationBanner(title: "Post not destroyed.", style: .danger)
            banner.duration = 1.0
            banner.show()
            print(error)
        }
    }

}

extension PostsViewController: CreatePostViewControllerDelegate {
    
    internal func onPostCreated(post: Post) {
        model.insertPostAtFront(post)
        let indexPath = IndexPath(row: 0, section: 0)
        postsView.tableView.insertRows(at: [indexPath], with: .automatic)
    }
}
