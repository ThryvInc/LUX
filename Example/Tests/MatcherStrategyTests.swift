//
//  MatcherStrategyTests.swift
//  LUX_Tests
//
//  Created by Elliot Schrock on 12/4/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
@testable import LUX

class MatcherStrategyTests: XCTestCase {
    func testPrefixMatcher() throws {
        XCTAssert(matchesPrefix("N", "Neo"))
        XCTAssertFalse(matchesPrefix("N", "Anderson"))
        XCTAssertFalse(matchesPrefix("A", "Neo Anderson"))
    }
    
    func testWordPrefixesMatcher() throws {
        XCTAssert(matchesWordsPrefixes("N A", "Neo Anderson"))
        XCTAssertFalse(matchesWordsPrefixes("e A", "Neo Anderson"))
    }
    
    func testContainsMatcher() throws {
        XCTAssert(matchesWithContains("N", "Neo"))
        XCTAssert(matchesWithContains("e", "Neo"))
        XCTAssertFalse(matchesWithContains("N", "Anderson"))
    }
    
    func testLowercase() throws {
        let string = "Neo Anderson"
        let optString: String? = string
        
        XCTAssertEqual(lowercased(string: string), "neo anderson")
        XCTAssertEqual(lowercased(string: optString), "neo anderson")
        XCTAssertNil(lowercased(string: nil))
    }
}
