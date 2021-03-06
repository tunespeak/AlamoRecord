/*
 
 The MIT License (MIT)
 Copyright (c) 2017 Tunespeak
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
 to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
 and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR
 ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
 THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

import Foundation

class ErrorParser: NSObject {

    /*
        Parses a failed request into an instance of an AlamoRecordError
        - parameter data: The data of the request
        - parameter error: The error of the request
        - parameter statusCode: The status code of the request
     */
    open class func parse<E: AlamoRecordError>(_ data: Data?, error: Error, statusCode: Int?) -> E {
        
        let code = statusCode
        
        guard let data = data,
            let statusCode = statusCode,
            (200...299).contains(statusCode) == false else {
                return E(error: error, statusCode: code)
        }
        
        do {
            return try JSONDecoder().decode(E.self, from: data)
        } catch (_) {
            return E(error: error, statusCode: nil)
        }
    }
    
}
