//
//  TextFitsTests.swift
//  LUX_Tests
//
//  Created by Elliot Schrock on 2/2/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
import LUX
import LithoOperators

class TextFitsTests: XCTestCase {
    
    func testAlwaysOneLine() throws {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 14)
        let textView = UITextView(frame: frame)
        setupTextViewFieldFont(textView)
        textView.text = ""
        
        let doesFit = doesTextFit(in: textView, replacing: NSMakeRange(0, 0), with: "Test")
        XCTAssert(doesFit)
    }

    func testBlocksTooManyLines() {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 14)
        let textView = UITextView(frame: frame)
        setupTextViewFieldFont(textView)
        textView.text = ""
        
        let doesFit = doesTextFit(in: textView, replacing: NSMakeRange(0, 0), with: "Test \n\"uh oh\"")
        XCTAssertFalse(doesFit)
    }

}

let setupTextViewFieldFont = set(\UITextView.font, UIFont.systemFont(ofSize: 12))
