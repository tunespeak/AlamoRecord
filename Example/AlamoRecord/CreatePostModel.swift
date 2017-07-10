//
//  CreatePostModel.swift
//  AlamoRecord
//
//  Created by Dalton Hinterscher on 7/9/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

class CreatePostModel: NSObject {

    func createPost(title: String,
                    body: String,
                    success: @escaping ((Post) -> Void),
                    failure: @escaping ((ApplicationError) -> Void)) {
        
        let parameters: [String: Any] = ["title": title,
                                         "body": body,
                                         "userId": 1]
        Post.create(parameters: parameters, success: success, failure: failure)
    }
}
