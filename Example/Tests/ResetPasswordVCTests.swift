//
//  ResetPasswordVCTests.swift
//  LUX_Tests
//
//  Created by Calvin Collins on 1/9/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
@testable import LUX
class ResetPasswordVCTests: XCTestCase {

    func testResetPasswordVC() {
        let vc = LUXResetPasswordViewController()
        var wasCalled: Bool = false
        vc.onSubmit = { _ in
            wasCalled = true
        }
        vc.submitPressed()
        XCTAssertTrue(wasCalled)
    }
    
    func testForgotPassword() {
        let vc = LUXForgotPasswordViewController()
        let identifierTextLabel = UITextField(frame: CGRect.zero)
        identifierTextLabel.text = "identifier"
        vc.identifierTextField = identifierTextLabel
        var wasCalled: Bool = false
        vc.onSubmit = { _ in
            wasCalled = true
        }
        vc.resetPressed()
        XCTAssertTrue(wasCalled)
    }

}
