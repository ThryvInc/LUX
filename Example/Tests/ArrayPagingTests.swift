//
//  ArrayPagingTests.swift
//  LUX_Tests
//
//  Created by Elliot Schrock on 4/17/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest

class ArrayPagingTests: XCTestCase {

    func testPaging() throws {
        let array1 = [0, 1, 2]
        XCTAssertEqual(array1.page(number: 0, per: 1), [0])
        XCTAssertEqual(array1.page(number: 1, per: 1), [1])
        XCTAssertEqual(array1.page(number: 2, per: 1), [2])
        XCTAssertEqual(array1.page(number: 0, per: 2), [0, 1])
    }
}
