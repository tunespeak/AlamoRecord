//
//  PostsModel.swift
//  AlamoRecord
//
//  Created by Dalton Hinterscher on 7/6/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

class PostsModel: NSObject {
    
    private var posts: [Post] = []
    
    func getAll(success: @escaping (() -> Void), failure: @escaping ((ApplicationError) -> Void)) {
        Post.all(success: { (posts: [Post]) in
            self.posts = posts
            success()
        }, failure: failure)
    }
    
    func destroyPost(at index: Int, success: @escaping (() -> Void), failure: @escaping ((ApplicationError) -> Void)) {
        let post = self.post(at: index)
        post.destroy(success: { 
            self.posts.remove(at: index)
            success()
        }, failure: failure)
    }

    func numberOfPosts() -> Int {
        return posts.count
    }
    
    func post(at index: Int) -> Post {
        return posts[index]
    }
    
    func insertPostAtFront(_ post: Post) {
        posts.insert(post, at: 0)
    }
}
