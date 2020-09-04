//
//  EverythingTests.swift
//  EverythingTests
//
//  Created by Sergey Okhotnikov on 30.08.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import XCTest
@testable import Everything

class EverythingTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        print("Testing")
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        XCTAssertEqual(1, Book.getLevel(2))
        XCTAssertEqual(1, Book.getLevel(3))
        
        XCTAssertEqual(2, Book.getLevel(4))
        XCTAssertEqual(2, Book.getLevel(5))
        XCTAssertEqual(2, Book.getLevel(6))
        
        XCTAssertEqual(3, Book.getLevel(7))
        XCTAssertEqual(3, Book.getLevel(8))
        XCTAssertEqual(3, Book.getLevel(9))
        XCTAssertEqual(3, Book.getLevel(10))
        
        XCTAssertEqual(4, Book.getLevel(11))
        XCTAssertEqual(4, Book.getLevel(12))
        XCTAssertEqual(4, Book.getLevel(13))
        XCTAssertEqual(4, Book.getLevel(14))
        XCTAssertEqual(4, Book.getLevel(15))
        
        XCTAssertEqual(5, Book.getLevel(16))
        XCTAssertEqual(5, Book.getLevel(17))
        XCTAssertEqual(5, Book.getLevel(18))
        XCTAssertEqual(5, Book.getLevel(19))
        XCTAssertEqual(5, Book.getLevel(20))
        XCTAssertEqual(5, Book.getLevel(21))
        
        XCTAssertEqual(6, Book.getLevel(22))
        XCTAssertEqual(6, Book.getLevel(23))
        XCTAssertEqual(6, Book.getLevel(24))
        XCTAssertEqual(6, Book.getLevel(25))
        XCTAssertEqual(6, Book.getLevel(26))
        XCTAssertEqual(6, Book.getLevel(27))
        XCTAssertEqual(6, Book.getLevel(28))

        
        XCTAssertEqual(7, Book.getLevel(29))
        XCTAssertEqual(7, Book.getLevel(30))
        XCTAssertEqual(7, Book.getLevel(31))
        XCTAssertEqual(7, Book.getLevel(32))
        XCTAssertEqual(7, Book.getLevel(33))
        XCTAssertEqual(7, Book.getLevel(34))
        XCTAssertEqual(7, Book.getLevel(35))
        XCTAssertEqual(7, Book.getLevel(36))
        
        XCTAssertEqual(8, Book.getLevel(37))

        XCTAssertEqual(20, Book.getLevel(211))
        XCTAssertEqual(20, Book.getLevel(231))
        XCTAssertEqual(21, Book.getLevel(232))
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
