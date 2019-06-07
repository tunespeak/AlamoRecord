//
//  Post.swift
//  AlamoRecord
//
//  Created by Dalton Hinterscher on 7/3/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import AlamoRecord

class Post: AlamoRecordObject<ApplicationURL, ApplicationError, Int> {

    let title: String
    let body: String
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        body = try container.decode(String.self, forKey: .body)
        try super.init(from: decoder)
    }
    
    override class var requestManager: ApplicationRequestManager {
        return ApplicationRequestManager.default
    }
    
    override class var root: String {
        return "post"
    }

    func getComments(success: @escaping (([Comment]) -> Void), failure: @escaping ((ApplicationError) -> Void)) {
        let url = ApplicationURL(url: "\(Post.pluralRoot)/\(id)/\(Comment.pluralRoot)")
        requestManager.mapObjects(.get, url: url, success: success, failure: failure)
    }
    
    private enum CodingKeys: String, CodingKey {
        case userId
        case title
        case body
    }
    
}
