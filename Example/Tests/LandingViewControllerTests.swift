//
//  LandingViewControllerTests.swift
//  LUX_Tests
//
//  Created by Calvin Collins on 1/1/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
@testable import LUX
class LandingViewControllerTests: XCTestCase {

    func testOnLoginOnSignup() {
        let vc = LUXLandingViewController()
        var loginCalled: Bool = false
        var signupCalled: Bool = false
        vc.onLoginPressed = { _ in
            loginCalled = true
        }
        vc.onSignUpPressed = { _ in
            signupCalled = true
        }
        vc.loginPressed()
        vc.signUpPressed()
        XCTAssert(signupCalled && loginCalled)
    }

}
