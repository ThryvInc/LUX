//
//  ValidatorTests.swift
//  LUX_Tests
//
//  Created by Calvin Collins on 12/27/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
@testable import LUX
import XCTest

class ValidatorTests: XCTestCase {
    func testNotEmptyValidator() {
        let validator = LUXNotEmptyTextValidator()
        XCTAssert(!validator.isTextValid(text: ""))
        XCTAssert(validator.isTextValid(text: "Hello"))
        XCTAssert(!validator.isTextValid(text: "      "))
    }
    
    func testLowerCaseValidator() {
        let validator = LUXLowercaseTextValidator()
        XCTAssert(!validator.isTextValid(text: "Calvin"))
        XCTAssert(validator.isTextValid(text: "calvin"))
    }
    
    func testLengthValidator() {
        let validator = LUXLengthTextValidator(length: 5)
        XCTAssert(!validator.isTextValid(text: "Cal"))
        XCTAssert(validator.isTextValid(text: "Calvin"))
    }
    
    func testEmailValidator() {
        let validator = LUXEmailTextValidator()
        XCTAssert(!validator.isTextValid(text: "Calvin"))
        XCTAssert(validator.isTextValid(text: "calvin@lithobyte.co"))
    }
}
