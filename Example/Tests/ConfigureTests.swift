//
//  ConfigureTests.swift
//  LUX_Tests
//
//  Created by Calvin Collins on 12/27/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import XCTest
@testable import LUX

class ConfigureTests: XCTestCase {
    func testConfigure() {
        let view = UIView()
        view.configure {
            $0.backgroundColor = .blue
        }
        XCTAssert(view.backgroundColor == .blue)
    }
}

extension UIView: Configure { }
