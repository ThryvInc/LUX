//
//  RefreshCallTests.swift
//  LUX_Tests
//
//  Created by Elliot Schrock on 12/8/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
@testable import LUX
@testable import FunNet

class RefreshCallTests: XCTestCase {
    var call: CombineNetCall = CombineNetCall(configuration: ServerConfiguration(host: "lithobyte.co", apiRoute: "api/v1"), Endpoint())

    func testRefresh() {
        var wasCalled = false
        
        let refeshManager = LUXRefreshableNetworkCallManager(call)
        
        call.firingFunc = { _ in
            wasCalled = true
        }
        
        XCTAssert(!wasCalled)
        refeshManager.refresh()
        XCTAssert(wasCalled)
    }

}
