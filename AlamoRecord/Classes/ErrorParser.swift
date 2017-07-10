//
//  ErrorParser.swift
//  Pods
//
//  Created by Dalton Hinterscher on 4/29/17.
//
//

import ObjectMapper

class ErrorParser: NSObject {

    /*
        Parses a failed request into an instance of an AlamoRecordError
        - parameter data: The data of the failed request
        - parameter error: The error of the failed request
     */
    open class func parse<E: AlamoRecordError>(_ data: Data?, error: NSError) -> E {
        
        guard let data = data else {
            return E(nsError: error)
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
            if let json = json as? [String: Any] {
                return Mapper<E>().map(JSON: json)!
            } else {
                return E(nsError: error)
            }
        } catch (_) {
            return E(nsError: error)
        }
    }
    
}
