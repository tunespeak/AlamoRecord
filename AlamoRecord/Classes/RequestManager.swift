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

import Alamofire

open class RequestManager<Url: AlamoRecordURL, ARError: AlamoRecordError, IDType: Codable>: NSObject {
    
    public typealias Parameters = [String: Any]
    public typealias ARObject = AlamoRecordObject<Url, ARError, IDType>
    
    /// If enabled, each request will be logged to the console
    public var loggingEnabled: Bool = true {
        didSet {
            Logger.loggingEnabled = self.loggingEnabled
        }
    }
    
    /// The configuration object of the RequestManager
    public let configuration: Configuration
    
    /// Responsible for creating and managing `Request` objects, as well as their underlying `NSURLSession`.
    public let session: Session
    
    public init(configuration: Configuration) {
        self.configuration = configuration
        session = Session(configuration: configuration.urlSessionConfiguration,
                          startRequestsImmediately: true,
                          interceptor: configuration.requestInterceptor)
    }
    
    /**
        Makes a request to the given URL. Each request goes through this method first.
        - parameter method: The HTTP method
        - parameter url: The URL that conforms to AlamoRecordURL
        - parameter parameters: The parameters. `nil` by default
        - parameter encoding: The parameter encoding. `JSONEncoding.default` by default
        - parameter headers: The HTTP headers. `nil` by default
     */
    @discardableResult
    open func makeRequest(_ method: Alamofire.HTTPMethod,
                          url: Url,
                          parameters: Parameters? = nil,
                          encoding: ParameterEncoding = JSONEncoding.default,
                          headers: HTTPHeaders? = nil) -> DataRequest {
  
        let request = session.request(url.absolute,
                                      method: method,
                                      parameters: parameters,
                                      encoding: encoding,
                                      headers: headers).validate()
        Logger.logRequest(method, url: url.absolute)
        return request
    }
    
    /**
        Makes a request to the given URL
        - parameter method: The HTTP method
        - parameter url: The URL that conforms to AlamoRecordURL
        - parameter parameters: The parameters. `nil` by default
        - parameter encoding: The parameter encoding. `JSONEncoding.default` by default
        - parameter headers: The HTTP headers. `nil` by default
        - parameter emptyBody: Wether or not the response will have an empty body. `false` by default
        - parameter success: The block to execute if the request succeeds
        - parameter failure: The block to execute if the request fails
     */
    @discardableResult
    open func makeRequest(_ method: Alamofire.HTTPMethod,
                          url: Url,
                          parameters: Parameters? = nil,
                          encoding: ParameterEncoding = JSONEncoding.default,
                          headers: HTTPHeaders? = nil,
                          emptyBody: Bool = false,
                          success: (() -> Void)?,
                          failure: ((ARError) -> Void)?) -> DataRequest {
        
        return makeRequest(method,
                           url: url,
                           parameters: parameters,
                           encoding: encoding,
                           headers: headers)
            .responseJSON { response in
                
                Logger.logFinishedResponse(response: response)
                
                guard emptyBody else {
                    switch response.result {
                    case .success:
                        self.onSuccess(success: success, response: response)
                    case .failure(let error):
                        self.onFailure(error: error, response: response, failure: failure)
                    }
                    return
                }
                
                if (200...299).contains(response.response?.statusCode ?? 0) {
                    self.onSuccess(success: success, response: response)
                } else {
                    self.onFailure(error: response.error!, response: response, failure: failure)
                }
        }
        
    }
    
    /**
         Makes a request and maps an object that conforms to the Mappable protocol
         - parameter method: The HTTP method
         - parameter url: The URL that conforms to AlamoRecordURL
         - parameter parameters: The parameters. `nil` by default
         - parameter keyPath: The keyPath to use when deserializing the JSON. `nil` by default.
         - parameter encoding: The parameter encoding. `JSONEncoding.default` by default.
         - parameter headers: The HTTP headers. `nil` by default.
         - parameter success: The block to execute if the request succeeds
         - parameter failure: The block to execute if the request fails
     */
    @discardableResult
    public func mapObject<C: Codable>(_ method: Alamofire.HTTPMethod,
                                      url: Url,
                                      parameters: Parameters? = nil,
                                      keyPath: String? = nil,
                                      encoding: ParameterEncoding = JSONEncoding.default,
                                      headers: HTTPHeaders? = nil,
                                      success: ((C) -> Void)?,
                                      failure: ((ARError) -> Void)?) -> DataRequest {
        
        return makeRequest(method,
                           url: url,
                           parameters: parameters,
                           encoding: encoding,
                           headers: headers)
            .responseDecodable(decoder: AlamoRecordDecoder(keyPath: keyPath),
                               completionHandler: { (response: DataResponse<C>) in
                Logger.logFinishedResponse(response: response)
                switch response.result {
                case .success(let value):
                    self.onSuccess(success: success, response: response, value: value)
                case .failure(let error):
                    self.onFailure(error: error, response: response, failure: failure)
                }
            })
    }
    
    /**
         Makes a request and maps an array of objects that conform to the Mappable protocol
         - parameter method: The HTTP method
         - parameter url: The URL that conforms to AlamoRecordURL
         - parameter parameters: The parameters. `nil` by default
         - parameter keyPath: The keyPath to use when deserializing the JSON. `nil` by default.
         - parameter encoding: The parameter encoding. `JSONEncoding.default` by default.
         - parameter headers: The HTTP headers. `nil` by default.
         - parameter success: The block to execute if the request succeeds
         - parameter failure: The block to execute if the request fails
     */
    @discardableResult
    public func mapObjects<C: Codable>(_ method: Alamofire.HTTPMethod,
                                       url: Url,
                                       parameters: Parameters? = nil,
                                       keyPath: String? = nil,
                                       encoding: ParameterEncoding = JSONEncoding.default,
                                       headers: HTTPHeaders? = nil,
                                       success: (([C]) -> Void)?,
                                       failure: ((ARError) -> Void)?) -> DataRequest {
        
        return makeRequest(method,
                           url: url,
                           parameters: parameters,
                           encoding: encoding,
                           headers: headers)
            .responseDecodable(decoder: AlamoRecordDecoder(keyPath: keyPath),
                               completionHandler: { (response: DataResponse<[C]>) in
                Logger.logFinishedResponse(response: response)
                switch response.result {
                case .success(let value):
                    self.onSuccess(success: success, response: response, value: value)
                case .failure(let error):
                    self.onFailure(error: error, response: response, failure: failure)
                }
            })
    }
    
    /**
         Makes a request and maps an AlamoRecordObject
         - parameter id: The id of the object to find
         - parameter parameters: The parameters. `nil` by default
         - parameter keyPath: The keyPath to use when deserializing the JSON. `nil` by default.
         - parameter encoding: The parameter encoding. `JSONEncoding.default` by default.
         - parameter headers: The HTTP headers. `nil` by default.
         - parameter success: The block to execute if the request succeeds
         - parameter failure: The block to execute if the request fails
     */
    @discardableResult
    public func findObject<O: ARObject>(id: IDType,
                                      parameters: Parameters? = nil,
                                      keyPath: String? = nil,
                                      encoding: ParameterEncoding = JSONEncoding.default,
                                      headers: HTTPHeaders? = nil,
                                      success:((O) -> Void)?,
                                      failure:((ARError) -> Void)?) -> DataRequest {
        
        return findObject(url: O.urlForFind(id),
                          parameters: parameters,
                          keyPath: keyPath,
                          encoding: encoding,
                          headers: headers,
                          success: success,
                          failure: failure)
    }
    
    /**
         Makes a request and maps an AlamoRecordObject
         - parameter url: The URL that conforms to AlamoRecordURL
         - parameter parameters: The parameters. `nil` by default
         - parameter keyPath: The keyPath to use when deserializing the JSON. `nil` by default.
         - parameter encoding: The parameter encoding. `JSONEncoding.default` by default.
         - parameter headers: The HTTP headers. `nil` by default.
         - parameter success: The block to execute if the request succeeds
         - parameter failure: The block to execute if the request fails
     */
    @discardableResult
    public func findObject<O: ARObject>(url: Url,
                                 parameters: Parameters? = nil,
                                 keyPath: String? = nil,
                                 encoding: ParameterEncoding = JSONEncoding.default,
                                 headers: HTTPHeaders? = nil,
                                 success:((O) -> Void)?,
                                 failure:((ARError) -> Void)?) -> DataRequest {
        
        return mapObject(.get,
                         url: url,
                         parameters: parameters,
                         keyPath: keyPath,
                         encoding: encoding,
                         headers: headers,
                         success: success,
                         failure: failure)
    }
    
    /**
         Makes a request and maps an array of AlamoRecordObjects
         - parameter url: The URL that conforms to AlamoRecordURL
         - parameter parameters: The parameters. `nil` by default
         - parameter keyPath: The keyPath to use when deserializing the JSON. `nil` by default.
         - parameter encoding: The parameter encoding. `JSONEncoding.default` by default.
         - parameter headers: The HTTP headers. `nil` by default.
         - parameter success: The block to execute if the request succeeds
         - parameter failure: The block to execute if the request fails
     */
    @discardableResult
    public func findArray<C: Codable>(_ url: Url,
                                      parameters: Parameters? = nil,
                                      keyPath: String? = nil,
                                      encoding: ParameterEncoding = JSONEncoding.default,
                                      headers: HTTPHeaders? = nil,
                                      success:(([C]) -> Void)?,
                                      failure:((ARError) -> Void)?) -> DataRequest {
        
        return mapObjects(.get,
                          url: url,
                          parameters: parameters,
                          keyPath: keyPath,
                          encoding: encoding,
                          headers: headers,
                          success: success,
                          failure: failure)
    }
    
    /**
         Makes a request and creates an AlamoRecordObjects
         - parameter parameters: The parameters. `nil` by default
         - parameter keyPath: The keyPath to use when deserializing the JSON. `nil` by default.
         - parameter encoding: The parameter encoding. `JSONEncoding.default` by default.
         - parameter headers: The HTTP headers. `nil` by default.
         - parameter success: The block to execute if the request succeeds
         - parameter failure: The block to execute if the request fails
     */
    @discardableResult
    public func createObject<O: ARObject>(parameters: Parameters? = nil,
                                                                 keyPath: String? = nil,
                                                                 encoding: ParameterEncoding = JSONEncoding.default,
                                                                 headers: HTTPHeaders? = nil,
                                                                 success:((O) -> Void)?,
                                                                 failure:((ARError) -> Void)?) -> DataRequest {
        
        return createObject(url: O.urlForCreate(),
                            parameters: parameters,
                            keyPath: keyPath,
                            encoding: encoding,
                            headers: headers,
                            success: success,
                            failure: failure)
    }

    /**
         Makes a request and creates an AlamoRecordObject
         - paramter url: The URL that conforms to AlamoRecordURL
         - parameter parameters: The parameters. `nil` by default
         - parameter keyPath: The keyPath to use when deserializing the JSON. `nil` by default.
         - parameter encoding: The parameter encoding. `JSONEncoding.default` by default.
         - parameter headers: The HTTP headers. `nil` by default.
         - parameter success: The block to execute if the request succeeds
         - parameter failure: The block to execute if the request fails
     */
    @discardableResult
    public func createObject<O: ARObject>(url: Url,
                                                                 parameters: Parameters? = nil,
                                                                 keyPath: String? = nil,
                                                                 encoding: ParameterEncoding = JSONEncoding.default,
                                                                 headers: HTTPHeaders? = nil,
                                                                 success:((O) -> Void)?,
                                                                 failure:((ARError) -> Void)?) -> DataRequest {
        
        return mapObject(.post,
                         url: url,
                         parameters: parameters,
                         keyPath: keyPath,
                         encoding: encoding,
                         headers: headers,
                         success: success,
                         failure: failure)
    }
    
    /**
         Makes a request and creates the object
         - parameter parameters: The parameters. `nil` by default
         - parameter encoding: The parameter encoding. `JSONEncoding.default` by default.
         - parameter headers: The HTTP headers. `nil` by default.
         - parameter success: The block to execute if the request succeeds
         - parameter failure: The block to execute if the request fails
     */
    @discardableResult
    public func createObject(url: Url,
                             parameters: Parameters? = nil,
                             encoding: ParameterEncoding = JSONEncoding.default,
                             headers: HTTPHeaders? = nil,
                             success:(() -> Void)?,
                             failure:((ARError) -> Void)?) -> DataRequest {
        
        return makeRequest(.post,
                           url: url,
                           parameters: parameters,
                           encoding: encoding,
                           headers: headers,
                           success: success,
                           failure: failure)
    }
    
    /**
         Makes a request and updates an AlamoRecordObject
         - parameter id: The id of the object to update
         - parameter parameters: The parameters. `nil` by default
         - parameter keyPath: The keyPath to use when deserializing the JSON. `nil` by default.
         - parameter encoding: The parameter encoding. `JSONEncoding.default` by default.
         - parameter headers: The HTTP headers. `nil` by default.
         - parameter success: The block to execute if the request succeeds
         - parameter failure: The block to execute if the request fails
     */
    @discardableResult
    public func updateObject<O: ARObject>(id: IDType,
                                                                       parameters: Parameters? = nil,
                                                                       keyPath: String? = nil,
                                                                       encoding: ParameterEncoding = JSONEncoding.default,
                                                                       headers: HTTPHeaders? = nil,
                                                                       success:((O) -> Void)?,
                                                                       failure:((ARError) -> Void)?) -> DataRequest {
        
        return updateObject(url: O.urlForUpdate(id),
                         parameters: parameters,
                         keyPath: keyPath,
                         encoding: encoding,
                         headers: headers,
                         success: success,
                         failure: failure)
    }
    
    /**
         Makes a request and updates an AlamoRecordObject
         - parameter url: The URL that conforms to AlamoRecordURL
         - parameter parameters: The parameters. `nil` by default
         - parameter keyPath: The keyPath to use when deserializing the JSON. `nil` by default.
         - parameter encoding: The parameter encoding. `JSONEncoding.default` by default.
         - parameter headers: The HTTP headers. `nil` by default.
         - parameter success: The block to execute if the request succeeds
         - parameter failure: The block to execute if the request fails
     */
    @discardableResult
    public func updateObject<O: ARObject>(url: Url,
                                                                       parameters: Parameters? = nil,
                                                                       keyPath: String? = nil,
                                                                       encoding: ParameterEncoding = JSONEncoding.default,
                                                                       headers: HTTPHeaders? = nil,
                                                                       success:((O) -> Void)?,
                                                                       failure:((ARError) -> Void)?) -> DataRequest {
        
        return mapObject(.put,
                         url: url,
                         parameters: parameters,
                         keyPath: keyPath,
                         encoding: encoding,
                         headers: headers,
                         success: success,
                         failure: failure)
    }
    
    /**
     Makes a request and updates an AlamoRecordObject
     - parameter url: The URL that conforms to AlamoRecordURL
     - parameter parameters: The parameters. `nil` by default
     - parameter keyPath: The keyPath to use when deserializing the JSON. `nil` by default.
     - parameter encoding: The parameter encoding. `JSONEncoding.default` by default.
     - parameter headers: The HTTP headers. `nil` by default.
     - parameter success: The block to execute if the request succeeds
     - parameter failure: The block to execute if the request fails
     */
    @discardableResult
    public func updateObject(url: Url,
                             parameters: Parameters? = nil,
                             encoding: ParameterEncoding = JSONEncoding.default,
                             headers: HTTPHeaders? = nil,
                             success:(() -> Void)?,
                             failure:((ARError) -> Void)?) -> DataRequest {
        
        return makeRequest(.put,
                           url: url,
                           parameters: parameters,
                           encoding: encoding,
                           headers: headers,
                           success: success,
                           failure: failure)
    }
    
    /**
         Makes a request and destroys an AlamoRecordObject
         - parameter url: The URL that conforms to AlamoRecordURL
         - parameter parameters: The parameters. `nil` by default
         - parameter encoding: The parameter encoding. `JSONEncoding.default` by default.
         - parameter headers: The HTTP headers. `nil` by default.
         - parameter success: The block to execute if the request succeeds
         - parameter failure: The block to execute if the request fails
     */
    @discardableResult
    public func destroyObject(url: Url,
                              parameters: Parameters? = nil,
                              encoding: ParameterEncoding = JSONEncoding.default,
                              headers: HTTPHeaders? = nil,
                              success:(() -> Void)?,
                              failure:((ARError) -> Void)?) -> DataRequest {
        
        return makeRequest(.delete,
                           url: url,
                           parameters: parameters,
                           encoding: encoding,
                           headers: headers,
                           success: success,
                           failure: failure)

    }
    
    /**
     Makes an upload request
     - parameter url: The URL that conforms to AlamoRecordURL
     - parameter keyPath: The keyPath to use when deserializing the JSON. `nil` by default.
     - parameter headers: The HTTP headers. `nil` by default.
     - parameter multipartFormData: The data to append
     - parameter progressHandler: Progress handler for following progress
     - parameter success: The block to execute if the request succeeds
     - parameter failure: The block to execute if the request fails
     */
    public func upload<C: Codable>(url: Url,
                                   keyPath: String? = nil,
                                   headers: HTTPHeaders? = nil,
                                   multipartFormData: @escaping ((MultipartFormData) -> Void),
                                   progressHandler: Request.ProgressHandler? = nil,
                                   success: ((C) -> Void)?,
                                   failure: ((ARError) -> Void)?) {
    
        session.upload(multipartFormData: multipartFormData, to: url.absolute, headers: headers)
            .uploadProgress { progress in
                progressHandler?(progress)
            }
            .responseDecodable(decoder: AlamoRecordDecoder(keyPath: keyPath),
                               completionHandler: { (response: DataResponse<C>) in
                switch response.result {
                case .success(let value):
                    success?(value)
                case .failure(let error):
                    failure?(ARError(error: error))
                }
            })
    }
    
    /**
         Makes a download request
         - parameter url: The URL that conforms to AlamoRecordURL
         - parameter destination: The destination to download the file to. If it is nil, then a default one will be assigned.
         - parameter progress: The progress handler of the download request
         - parameter success: The block to execute if the request succeeds
         - parameter failure: The block to execute if the request fails
     */
    public func download(url: Url,
                         destination: DownloadRequest.Destination? = nil,
                         progress: Request.ProgressHandler? = nil,
                         success: @escaping ((URL?) -> Void),
                         failure: @escaping ((ARError) -> Void)) {
        
        let finalDestination: DownloadRequest.Destination
        
        if let destination = destination {
            finalDestination = destination
        } else {
            finalDestination = { _, _ in
                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let fileURL = documentsURL.appendingPathComponent("default_destination")
                return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
            }
        }
    
        session.download(url.absolute, to: finalDestination).downloadProgress(closure: { (prog) in
            progress?(prog)
        }).response { response in
            if let error = response.error {
                self.onFailure(error: error, response: response, failure: failure)
            } else {
                self.onSuccess(success: success, response: response)
            }
        }
    }

    /**
         Performs any logic associated with a successful DataResponse<Any>
         - parameter success: The block to execute if the request succeeds
         - parameter response: The response of the request
     */
    private func onSuccess(success: (() -> Void)?, response: DataResponse<Any>) {
        sendEventsToObservers(response: response.response)
        success?()
    }
    
    /**
         Performs any logic associated with a successful DataResponse<C>
         - parameter success: The block to execute if the request succeeds
         - parameter response: The response of the request
     */
    private func onSuccess<C: Codable>(success: ((C) -> Void)?, response: DataResponse<C>, value: C) {
        sendEventsToObservers(response: response.response)
        success?(value)
    }
    
    /**
         Performs any logic associated with a successful DataResponse<[C]>
         - parameter success: The block to execute if the request succeeds
         - parameter response: The response of the request
     */
    private func onSuccess<C: Codable>(success: (([C]) -> Void)?, response: DataResponse<[C]>, value: [C]) {
        sendEventsToObservers(response: response.response)
        success?(value)
    }
    
    /**
         Performs any logic associated with a successful DefaultDownloadResponse
         - parameter success: The block to execute if the request succeeds
         - parameter response: The response of the request
     */
    private func onSuccess(success: ((URL?) -> Void)?,
                           response: DownloadResponse<URL?>) {
        sendEventsToObservers(response: response.response)
        success?(response.fileURL)
    }
    
    /**
         Sends events to any observers that may exist on the configuration object
         - parameter response: The HTTPURLResponse
     */
    private func sendEventsToObservers(response: HTTPURLResponse?) {
        guard let response = response else {
            return
        }
        
        if let url = response.url?.absoluteString {
            configuration.requestObserver?.onRequestFinished(with: url)
        }
        
        configuration.statusCodeObserver?.onStatusCode(statusCode: response.statusCode, error: nil)
    }
    
    /**
         Performs any logic associated with a failed DataResponse<Any>
         - parameter error: The error the request returned
         - parameter response: The response of the request
         - parameter failure: The block to execute if the request fails
     */
    private func onFailure(error: Error,
                           response: DataResponse<Any>,
                           failure:((ARError) -> Void)?) {
        onFailure(error: error,
                  responseData: response.data,
                  statusCode: response.response?.statusCode,
                  failure: failure)
    }

    /**
         Performs any logic associated with a failed DataResponse<C>
         - parameter error: The error the request returned
         - parameter response: The response of the request
         - parameter failure: The block to execute if the request fails
     */
    private func onFailure<C: Codable>(error: Error,
                                       response: DataResponse<C>,
                                       failure:((ARError) -> Void)?) {
        onFailure(error: error,
                  responseData: response.data,
                  statusCode: response.response?.statusCode,
                  failure: failure)
    }
    
    /**
         Performs any logic associated with a failed DataResponse<[C]>
         - parameter error: The error the request returned
         - parameter response: The response of the request
         - parameter failure: The block to execute if the request fails
     */
    private func onFailure<C: Codable>(error: Error,
                                       response: DataResponse<[C]>,
                                       failure:((ARError) -> Void)?) {
        onFailure(error: error,
                  responseData: response.data,
                  statusCode: response.response?.statusCode,
                  failure: failure)
    }
    
    /**
         Performs any logic associated with a failed DefaultDownloadResponse
         - parameter error: The error the request returned
         - parameter response: The response of the request
         - parameter failure: The block to execute if the request fails
     */
    private func onFailure(error: Error,
                           response: DownloadResponse<URL?>,
                           failure:((ARError) -> Void)?) {
        onFailure(error: error,
                  responseData: nil,
                  statusCode: response.response?.statusCode,
                  failure: failure)
    }
    
    /**
         Performs any logic associated with a failed request. All failed requests go through here.
         - parameter error: The error the request returned
         - parameter responseData: The responseData of the failed request
         - parameter statusCode: The statusCode of the failed request
         - parameter failure: The block to execute if the request fails
     */
    private func onFailure(error: Error,
                           responseData: Data?,
                           statusCode: Int?,
                           failure: ((ARError) -> Void)?) {
        
        let nsError = error as NSError
        if configuration.ignoredErrorCodes.contains(nsError.code) {
            return
        }
        
        let error: ARError = ErrorParser.parse(responseData, error: nsError, statusCode: statusCode)
        
        if let statusCode = statusCode {
            configuration.statusCodeObserver?.onStatusCode(statusCode: statusCode, error: error)
        }

        failure?(error)
    }

}
