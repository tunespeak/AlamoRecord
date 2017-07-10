//
//  AlamoRecordURLProtocol.swift
//  Pods
//
//  Created by Dalton Hinterscher on 4/29/17.
//
//

public protocol URLProtocol {
    
    /// The entire url of a particular instance. Example: https://www.domain.com/objects/id
    var absolute: String { get }
    
    init(url: String)
}
