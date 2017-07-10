//
//  CommentsViewController.swift
//  AlamoRecord
//
//  Created by Dalton Hinterscher on 7/7/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

class CommentsViewController: UIViewController {

    fileprivate var model: CommentsModel!
    fileprivate var commentsView: CommentsView {
        return view as! CommentsView
    }
    
    init(model: CommentsModel) {
        super.init(nibName: nil, bundle: nil)
        edgesForExtendedLayout = UIRectEdge()
        self.model = model
        view = CommentsView(delegate: self)
        title = Comment.pluralRoot.capitalized
        
        model.getComments(success: { 
            self.commentsView.tableView.reloadData()
        }) { (error) in
            print(error)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension CommentsViewController: CommentsViewDelegate {
    
    internal func numberOfComments() -> Int {
        return model.numberOfComments()
    }
    
    internal func comment(at index: Int) -> Comment {
        return model.comment(at: index)
    }
}
