//
//  LoginViewModelTests.swift
//  LithoUXComponents_Tests
//
//  Created by Elliot Schrock on 10/9/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
@testable import LUX
@testable import FunNet

class LoginViewModelTests: XCTestCase {

    func testSubmitButtonDisabledOnLoad() {
        var wasCalled = false
        
        let viewModel = LUXLoginViewModel(credsCall: CombineNetCall(configuration: ServerConfiguration(host: "lithobyte.co", apiRoute: "api/v1"), Endpoint()), loginModelToJson: { _, _ in Human() })
        
        let cancel = viewModel.outputs.submitButtonEnabledPublisher.sink { enable in
            XCTAssertFalse(enable)
            wasCalled = true
        }
        
        viewModel.inputs.viewDidLoad()
        
        XCTAssert(wasCalled)
        cancel.cancel()
    }

    func testSubmitButtonDisabledOnEmptyCredentials() {
        var wasCalled = false
        
        let viewModel = LUXLoginViewModel(credsCall: CombineNetCall(configuration: ServerConfiguration(host: "lithobyte.co", apiRoute: "api/v1"), Endpoint()),
                                           loginModelToJson: { _, _ in Human() })
        
        let cancel = viewModel.outputs.submitButtonEnabledPublisher.sink { enable in
            XCTAssertFalse(enable)
            wasCalled = true
        }
        
        viewModel.inputs.usernameChanged(username: "")
        viewModel.inputs.passwordChanged(password: "")
        
        XCTAssert(wasCalled)
        cancel.cancel()
    }

    func testSubmitButtonDisabledOnHalfEmptyCredentials() {
        var wasCalled = false
        
        let viewModel = LUXLoginViewModel(credsCall: CombineNetCall(configuration: ServerConfiguration(host: "lithobyte.co", apiRoute: "api/v1"), Endpoint()),
                                           loginModelToJson: { _, _ in Human() })
        
        let cancel = viewModel.outputs.submitButtonEnabledPublisher.sink { enable in
            XCTAssertFalse(enable)
            wasCalled = true
        }
        
        viewModel.inputs.usernameChanged(username: "elliot")
        viewModel.inputs.passwordChanged(password: "")
        viewModel.inputs.usernameChanged(username: "")
        viewModel.inputs.passwordChanged(password: "password")
        
        XCTAssert(wasCalled)
        cancel.cancel()
    }

    func testSubmitButtonDisabledOnHalfFullCredentials() {
        var wasCalled = false
        var wasCalledTwice = false
        
        let viewModel = LUXLoginViewModel(credsCall: CombineNetCall(configuration: ServerConfiguration(host: "lithobyte.co", apiRoute: "api/v1"), Endpoint()),
                                           loginModelToJson: { _, _ in Human() })
        
        let cancel = viewModel.outputs.submitButtonEnabledPublisher.sinkThrough { enable in
            XCTAssertFalse(enable)
            if wasCalled {
                wasCalledTwice = !enable
            }
            wasCalled = true
        }
        
        viewModel.inputs.viewDidLoad()
        viewModel.inputs.usernameChanged(username: "elliot")
        
        XCTAssert(wasCalled)
        XCTAssert(wasCalledTwice)
        cancel.cancel()
    }

    func testSubmitButtonDisabledOnVisibleSpinner() {
        var callCount = 0
        
        let viewModel = LUXLoginViewModel(credsCall: CombineNetCall(configuration: ServerConfiguration(host: "lithobyte.co", apiRoute: "api/v1"), Endpoint()), loginModelToJson: { _, _ in Human() })
        
        let cancel = viewModel.outputs.submitButtonEnabledPublisher.sinkThrough { enable in
            callCount += 1
            if callCount != 3 {
                XCTAssertFalse(enable)
            }
        }
        
        viewModel.inputs.viewDidLoad()
        viewModel.inputs.usernameChanged(username: "elliot")
        viewModel.inputs.passwordChanged(password: "password")
        viewModel.activityIndicatorVisibleSubject.send(true)
        
        XCTAssertEqual(callCount, 4)
        cancel.cancel()
    }

    func testSubmitButtonEnabledOnValidCredentials() {
        var wasCalled = false
        
        let viewModel = LUXLoginViewModel(credsCall: CombineNetCall(configuration: ServerConfiguration(host: "lithobyte.co", apiRoute: "api/v1"), Endpoint()),
                                           loginModelToJson: { _, _ in Human() })
        
        let cancel = viewModel.outputs.submitButtonEnabledPublisher.sinkThrough { enable in
            if wasCalled {
                XCTAssert(enable)
            } else {
                XCTAssertFalse(enable)
            }
            wasCalled = true
        }
        
        viewModel.inputs.usernameChanged(username: "elliot")
        viewModel.inputs.passwordChanged(password: "password")
        
        XCTAssert(wasCalled)
        cancel.cancel()
    }

    func testSubmitButtonDisabledUntilValidCredentials() {
        var callCount = 0
        
        let viewModel = LUXLoginViewModel(credsCall: CombineNetCall(configuration: ServerConfiguration(host: "lithobyte.co", apiRoute: "api/v1"), Endpoint()), loginModelToJson: { _, _ in Human() })
        
        let cancel = viewModel.outputs.submitButtonEnabledPublisher.sinkThrough { enable in
            callCount += 1
            if callCount < 7 {
                XCTAssertFalse(enable)
            } else {
                XCTAssert(enable)
            }
        }
        
        viewModel.inputs.viewDidLoad()
        viewModel.inputs.usernameChanged(username: "elliot")
        viewModel.inputs.passwordChanged(password: "")
        viewModel.inputs.usernameChanged(username: "")
        viewModel.inputs.passwordChanged(password: "password")
        viewModel.activityIndicatorVisibleSubject.send(true)
        viewModel.inputs.usernameChanged(username: "elliot")
        viewModel.activityIndicatorVisibleSubject.send(false)
        
        XCTAssertEqual(callCount, 8)
        cancel.cancel()
    }

    func testMakesCallOnSubmit() {
        var wasCalled = false
        var spinnerVisible = false
        
        let call = CombineNetCall(configuration: ServerConfiguration(host: "lithobyte.co", apiRoute: "api/v1"), Endpoint())
        call.firingFunc = { _ in wasCalled = true }
        let viewModel = LUXLoginViewModel(credsCall: call, loginModelToJson: { _, _ in Human() })
        
        let cancel = viewModel.outputs.activityIndicatorVisiblePublisher.sink { enable in
            spinnerVisible = enable
        }
        
        viewModel.inputs.usernameChanged(username: "elliot")
        viewModel.inputs.passwordChanged(password: "password")
        viewModel.inputs.submitButtonPressed()
        
        XCTAssert(wasCalled)
        XCTAssert(spinnerVisible)
        cancel.cancel()
    }

}
