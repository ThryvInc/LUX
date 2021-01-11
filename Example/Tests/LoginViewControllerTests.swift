//
//  LoginViewControllerTests.swift
//  LUX_Tests
//
//  Created by Calvin Collins on 1/9/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
@testable import LUX

class MyLoginViewController: LUXLoginViewController {
    
    var usernameWasChanged: Bool = false
    var passwordWasChanged: Bool = false
    var loginPressed: Bool = false
    var signupWasPressed: Bool = false
    var forgotPasswordWasPressed: Bool = false
    var termsWasPressed: Bool = false
    
    
    override func usernameChanged() {
        usernameWasChanged = true
        super.usernameChanged()
    }
    
    override func passwordChanged() {
        passwordWasChanged = true
        super.passwordChanged()
    }
    
    override func loginButtonPressed() {
        loginPressed = true
        super.loginButtonPressed()
    }
    
    override func signUpPressed() {
        signupWasPressed = true
    }
    
    override func forgotPasswordPressed() {
        forgotPasswordWasPressed = true
    }
    
    override func termsPressed() {
        termsWasPressed = true
    }
}

class LoginViewControllerTests: XCTestCase {

    func testViewController() {
        let vc = MyLoginViewController()
        let model = LUXLoginViewModel(loginModelToJson: {_, _ in return "" })
        vc.loginViewModel = model
        vc.viewDidLoad()
        
        let username = UITextField(frame: .zero)
        let password = UITextField(frame: .zero)
        
        vc.usernameTextField = username
        vc.usernameTextField?.text = "username"
        vc.passwordTextField = password
        vc.passwordTextField?.text = "password"
        
        vc.usernameChanged()
        vc.passwordChanged()
        vc.loginButtonPressed()
        vc.signUpPressed()
        vc.forgotPasswordPressed()
        vc.termsPressed()
        
        XCTAssertTrue(vc.usernameWasChanged)
        XCTAssertTrue(vc.passwordWasChanged)
        XCTAssertTrue(vc.loginPressed)
        XCTAssertTrue(vc.signupWasPressed)
        XCTAssertTrue(vc.forgotPasswordWasPressed)
        XCTAssertTrue(vc.termsWasPressed)
        
    }

}
