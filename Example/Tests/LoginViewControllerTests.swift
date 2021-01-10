//
//  LoginViewControllerTests.swift
//  LUX_Tests
//
//  Created by Calvin Collins on 1/9/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
@testable import LUX
class LoginViewControllerTests: XCTestCase {

    func testViewController() {
        let vc = LUXLoginViewController()
        let model = LUXLoginViewModel(loginModelToJson: {_, _ in return "" })
        vc.loginViewModel = model
        vc.viewDidLoad()
    }

}
