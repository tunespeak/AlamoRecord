//
//  AlamoRecordTests.swift
//  Tests
//
//  Created by Dalton Hinterscher on 7/3/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import AlamoRecord
import XCTest

class AlamoRecordTests: XCTestCase {
    
    internal var validationExpectation: XCTestExpectation?
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testThatCreateHelperWorks() {
        initializeExpectation()
        let parameters: [String : String] = ["userId": "4",
                                             "title" : "AlamoRecord Title",
                                             "body": "AlamoRecord Body"]
        Post.create(parameters: parameters, success: { (post: Post) in
            self.validationExpectation?.fulfill()
            XCTAssertEqual([parameters["userId"]!, parameters["title"]!, parameters["body"]!],
                           ["\(post.userId!)", post.title, post.body])
        }) { (error) in
            self.validationExpectation?.fulfill()
            XCTFail(error.description)
        }
        
         waitForRequestToFinish()
    }
    
    func testThatFindHelperWorks() {
        initializeExpectation()
        Post.find(id: 1, success: { (post: Post) in
            self.validationExpectation?.fulfill()
            let userId: String = "1"
            let id: String = "1"
            let title: String = "sunt aut facere repellat provident occaecati excepturi optio reprehenderit"
            let body: String = "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"
            XCTAssertEqual([userId, id, title, body],
                           ["\(post.userId!)", "\(post.id!)", post.title, post.body])
        }) { (error) in
            self.validationExpectation?.fulfill()
            XCTFail(error.description)
        }
        
        waitForRequestToFinish()
    }
    
    func testThatUpdateHelperWorksOnClass() {
        initializeExpectation()
        let parameters: [String : String] = ["title" : "AlamoRecord Title Updated"]
        Post.update(id: 1, parameters: parameters, success: { (post: Post) in
            self.validationExpectation?.fulfill()
            XCTAssertEqual(parameters["title"]!, post.title)
        }) { (error) in
            self.validationExpectation?.fulfill()
            XCTFail(error.description)
        }
        
        waitForRequestToFinish()
    }
    
    func testThatUpdateHelperWorksOnInstance() {
        initializeExpectation()
        let parameters: [String : String] = ["title" : "AlamoRecord Title Updated"]
        Post.find(id: 1, success: { (post: Post) in
            
            post.update(parameters: parameters, success: { (updatedPost: Post) in
                self.validationExpectation?.fulfill()
                XCTAssertEqual(parameters["title"]!, updatedPost.title)
            }, failure: { (error) in
                self.validationExpectation?.fulfill()
                XCTFail(error.description)
            })
            
        }) { (error) in
            self.validationExpectation?.fulfill()
            XCTFail(error.description)
        }
        
        waitForRequestToFinish()
    }
    
    func testThatDestroyHelperWorksOnClass() {
        initializeExpectation()
        Post.destroy(id: 1, success: { 
            self.validationExpectation?.fulfill()
            XCTAssert(true)
        }) { (error) in
            self.validationExpectation?.fulfill()
            XCTFail(error.description)
        }
        
        waitForRequestToFinish()
    }
    
    func testThatDestroyHelperWorksOnInstance() {
        initializeExpectation()
        Post.find(id: 1, success: { (post: Post) in
            
            post.destroy(success: { 
                self.validationExpectation?.fulfill()
                XCTAssert(true)
            }, failure: { (error) in
                self.validationExpectation?.fulfill()
                XCTFail(error.description)
            })
            
        }) { (error) in
            self.validationExpectation?.fulfill()
            XCTFail(error.description)
        }
        
        waitForRequestToFinish()
    }
    
    func testThatUrlForCreateReturnsTheCorrectUrl() {
        XCTAssertEqual("https://jsonplaceholder.typicode.com/posts", Post.urlForCreate().absolute)
    }
    
    func testThatUrlForFindReturnsTheCorrectUrl() {
        XCTAssertEqual("https://jsonplaceholder.typicode.com/posts/1", Post.urlForFind(1).absolute)
    }
    
    func testThatUrlForUpdateReturnsTheCorrectUrl() {
        XCTAssertEqual("https://jsonplaceholder.typicode.com/posts/1", Post.urlForUpdate(1).absolute)
    }
    
    func testThatUrlForDestroyReturnsTheCorrectUrl() {
        XCTAssertEqual("https://jsonplaceholder.typicode.com/posts/1", Post.urlForDestroy(1).absolute)
    }
    
    func testThatUrlForAllReturnsTheCorrectUrl() {
        XCTAssertEqual("https://jsonplaceholder.typicode.com/posts", Post.urlForAll().absolute)
    }
    
    func initializeExpectation() {
        validationExpectation = expectation(description: "XCTestExpectation")
    }
    
    func waitForRequestToFinish(){
        
        waitForExpectations(timeout: 60.0) { (error) in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
        }
    }
    
}
