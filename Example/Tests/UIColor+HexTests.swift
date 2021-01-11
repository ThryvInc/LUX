//
//  UIColor+HexTests.swift
//  LUX_Tests
//
//  Created by Calvin Collins on 12/27/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
@testable import FunNet
class UIColor_HexTests: XCTestCase {

    func testUIColorHex() {
        let color1 = UIColor(hex: 0x000000)
        let color2 = UIColor.uicolorFromHex(rgbValue: 0x000000)
        XCTAssert(color1 == color2)
    }

}
