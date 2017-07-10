//
//  RequestObserver.swift
//  Pods
//
//  Created by Dalton Hinterscher on 6/28/17.
//
//

import UIKit

public protocol RequestObserver {
    
    /*
        After each request is finished, this method will be called if the url of the request existed.
        parameter url: The url of the finished request
    */
    func onRequestFinished(with url: String)
}

