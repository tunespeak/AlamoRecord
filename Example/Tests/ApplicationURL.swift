//
//  ApplicationURL.swift
//  AlamoRecord
//
//  Created by Dalton Hinterscher on 7/3/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import AlamoRecord

class ApplicationURL: URLProtocol {

    var absolute: String {
        return "https://jsonplaceholder.typicode.com/\(url)"
    }
    
    private var url: String
    
    required init(url: String) {
        self.url = url
    }
}
