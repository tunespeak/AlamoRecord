//
//  Comment.swift
//  AlamoRecord
//
//  Created by Dalton Hinterscher on 7/7/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import ObjectMapper
import UIKit

class Comment: AlamoRecordObject<ApplicationURL, ApplicationError> {

    class override var requestManager: RequestManager<ApplicationURL, ApplicationError> {
        return ApplicationRequestManager.default
    }
    
    override class var root: String {
        return "comment"
    }
    
    private(set) var postId: Int!
    private(set) var name: String!
    private(set) var email: String!
    private(set) var body: String!
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        postId <- map["postId"]
        name <- map["name"]
        email <- map["email"]
        body <- map["body"]
    }
}
