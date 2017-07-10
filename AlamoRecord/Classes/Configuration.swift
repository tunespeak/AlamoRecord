//
//  Configuration.swift
//  Pods
//
//  Created by Dalton Hinterscher on 4/29/17.
//
//

import Alamofire

open class Configuration: NSObject {
    
    /// See URLSessionConfiguration Documentation
    public var urlSessionConfiguration: URLSessionConfiguration!
    
    /// See Alamofire.RequestRetrier Documentation
    public var requestRetrier: RequestRetrier?
    
    /// See Alamofire.RequestAdapter Documentation
    public var requestAdapter: RequestAdapter?
    
    /// The status codes this configuration should ignore for failed requests
    public var ignoredErrorCodes: [Int] = []
    
    /// Observer that gets called after each requests finishes
    public var statusCodeObserver: StatusCodeObserver?
    
    /// Observer that gets called after each requests finishes
    public var requestObserver: RequestObserver?
    
    public override init() {
        super.init()
        
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else {
            fatalError("AlamoRecord requires that your bundleIdentifier is not nil. Update your plist to include a bundle identifier.")
        }
        
        urlSessionConfiguration = URLSessionConfiguration.background(withIdentifier: "\(bundleIdentifier).background")
        urlSessionConfiguration.timeoutIntervalForRequest = 30.0
        urlSessionConfiguration.timeoutIntervalForResource = 30.0
    }
    
    public convenience init(builder: (Configuration) -> ()) {
        self.init()
        builder(self)
    }
}
