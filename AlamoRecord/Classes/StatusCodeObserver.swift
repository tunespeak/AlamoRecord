//
//  StatusCodeObserver.swift
//  Pods
//
//  Created by Dalton Hinterscher on 4/30/17.
//
//

public protocol StatusCodeObserver {
    
    /*
        After each request is finished, this method will be called if the status code of the request existed.
        parameter statusCode: The status code of the finished request
     */
    func onStatusCode(statusCode: Int)
}

