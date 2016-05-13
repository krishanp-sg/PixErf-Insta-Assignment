//
//  PixErfTest_InstagramTests.swift
//  PixErfTest-InstagramTests
//
//  Created by Krishantha Sunil Premaretna on 9/5/16.
//  Copyright © 2016 Krishantha Sunil Premaretna. All rights reserved.
//

import XCTest
@testable import PixErfTest_Instagram

class PixErfTest_InstagramTests: XCTestCase {
    
    let commonUtility : CommonUtility;
    override func setUp() {
        super.setUp()
        
    
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        commonUtility.readServicesPlistFile();
        let instagramDictionary = commonUtility.readVlueFromServicePlist("Instagram")
        XCTAssertNotNil(instagramDictionary);
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
