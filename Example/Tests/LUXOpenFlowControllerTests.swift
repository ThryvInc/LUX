//
//  LUXOpenFlowControllerTests.swift
//  LUX_Tests
//
//  Created by Calvin Collins on 1/9/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
@testable import LUX

class LUXOpenFlowControllerTests: XCTestCase {

    func testOpenFlowController() {
        let controller = LUXAppOpenFlowController()
        XCTAssertNil(controller.initialVC())
    }

}
