//
//  Post.swift
//  AlamoRecord
//
//  Created by Dalton Hinterscher on 7/3/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import AlamoRecord
import ObjectMapper

class Post: AlamoRecordObject<ApplicationURL, ApplicationError> {
    
    override class var requestManager: RequestManager<ApplicationURL, ApplicationError> {
        return ApplicationRequestManager.default
    }
    
    override class var root: String {
        return "post"
    }

    private(set) var userId: Int!
    private(set) var title: String!
    private(set) var body: String!
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        userId <- map["userId"]
        title <- map["title"]
        body <- map["body"]
    }

    func getComments(success: @escaping (([Comment]) -> Void), failure: @escaping ((ApplicationError) -> Void)) {
        let url = ApplicationURL(url: "\(Post.pluralRoot)/\(id!)/\(Comment.pluralRoot)")
        requestManager.mapObjects(.get, url: url, success: success, failure: failure)
    }
}
