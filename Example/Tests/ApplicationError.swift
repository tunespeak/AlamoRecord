//
//  ApplicationError.swift
//  AlamoRecord
//
//  Created by Dalton Hinterscher on 7/3/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import AlamoRecord
import ObjectMapper

class ApplicationError: AlamoRecordError {

    required init(nsError: NSError) {
        super.init(nsError: nsError)
    }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
    }
}
