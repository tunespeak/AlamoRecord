//
//  ApplicationURL.swift
//  AlamoRecord
//
//  Created by Dalton Hinterscher on 7/3/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import AlamoRecord

class ApplicationURL: AlamoRecordURL {

    var absolute: String {
        return isCompletePath ? url : "https://jsonplaceholder.typicode.com/\(url)"
    }
    
    private var url: String
    private var isCompletePath: Bool
    
    required init(url: String) {
        self.url = url
        self.isCompletePath = false
    }
    
    required init(url: String, isCompletePath: Bool) {
        self.url = url
        self.isCompletePath = isCompletePath
    }
}
