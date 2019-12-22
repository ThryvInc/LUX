//
//  SinkThroughTests.swift
//  LUX_Tests
//
//  Created by Elliot Schrock on 12/8/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
@testable import LUX
@testable import FunNet
import Combine

class SinkThroughTests: XCTestCase {

    func testSinkThrough() {
        let someClass = SomeClass()
        let cancel = someClass.$property.sinkThrough {
            XCTAssertEqual($0, 2)
        }
        someClass.property = 2
        cancel.cancel()
    }

}
