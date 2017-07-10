//
//  CommentsModel.swift
//  AlamoRecord
//
//  Created by Dalton Hinterscher on 7/7/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

class CommentsModel: NSObject {

    private var post: Post!
    private var comments: [Comment] = []
    
    init(post: Post) {
        self.post = post
    }
    
    func getComments(success: @escaping (() -> Void), failure: @escaping ((ApplicationError) -> Void)) {
        post.getComments(success: { (comments) in
            self.comments = comments
            success()
        }, failure: failure)
    }
    
    func numberOfComments() -> Int {
        return comments.count
    }
    
    func comment(at index: Int) -> Comment {
        return comments[index]
    }

}
