//
//  NilAndEmptyMatchStrategyTests.swift
//  LUX_Tests
//
//  Created by Elliot Schrock on 12/4/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
@testable import LUX

class NilAndEmptyMatchStrategyTests: XCTestCase {
    func testAllMatchNilAndEmpty() {
        let functionTuple = nilAndEmptyMatchers(for: .allMatchNilAndEmpty)
        
        XCTAssert(functionTuple.0())
        XCTAssert(functionTuple.1())
    }
    
    func testAllMatchNilNoneMatchEmpty() {
        let functionTuple = nilAndEmptyMatchers(for: .allMatchNilNoneMatchEmpty)
        
        XCTAssert(functionTuple.0())
        XCTAssertFalse(functionTuple.1())
    }
    
    func testNoneMatchNilAllMatchEmpty() {
        let functionTuple = nilAndEmptyMatchers(for: .noneMatchNilAllMatchEmpty)
        
        XCTAssertFalse(functionTuple.0())
        XCTAssert(functionTuple.1())
    }
    
    func testNoneMatchNilAndEmpty() {
        let functionTuple = nilAndEmptyMatchers(for: .noneMatchNilNoneMatchEmpty)
        
        XCTAssertFalse(functionTuple.0())
        XCTAssertFalse(functionTuple.1())
    }
}
