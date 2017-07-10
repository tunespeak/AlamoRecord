//
//  Error.swift
//  Pods
//
//  Created by Dalton Hinterscher on 4/29/17.
//
//

import ObjectMapper

open class AlamoRecordError: NSObject, Mappable {
    
    override open var description: String {
        guard let nsError = nsError else {
            return "[AlamoRecordError] No description could be found for this error."
        }
        return "[AlamoRecordError] \(nsError.localizedDescription)"
    }
    
    /// The error of the failed request
    public var nsError: NSError?
    
    required public init(nsError: NSError) {
        self.nsError = nsError
    }
    
    required public init?(map: Map) {
        super.init()
        mapping(map: map)
    }
    
    open func mapping(map: Map) {}
}
