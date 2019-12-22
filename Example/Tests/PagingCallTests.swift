//
//  PagingCallTests.swift
//  LUX_Tests
//
//  Created by Elliot Schrock on 12/8/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
@testable import LUX
@testable import FunNet
import Combine

class PagingCallTests: XCTestCase {
    var call: CombineNetCall = CombineNetCall(configuration: ServerConfiguration(host: "lithobyte.co", apiRoute: "api/v1"), Endpoint())
    
    func testPageNotCalledOnViewLoad() {
        var wasCalled = false
        
        let manager = LUXPageableModelManager(call, firstPageValue: 1)
        
        call.firingFunc = { _ in
            wasCalled = true
        }
        
        manager.viewDidLoad()
        
        XCTAssert(!wasCalled)
    }

    func testRefresh() {
        var wasCalled = false
        
        let manager = LUXPageableModelManager(call, firstPageValue: 1)
        
        call.firingFunc = { _ in
            wasCalled = true
        }
        
        manager.viewDidLoad()
        manager.refresh()
        
        XCTAssertEqual(manager.page, 1)
        XCTAssert(wasCalled)
    }
    
    func testNextPage() {
        var wasCalled = false
        var callCount = 0
        
        let manager = LUXPageableModelManager(call, firstPageValue: 1)
        
        call.firingFunc = { _ in
            wasCalled = true
            callCount += 1
        }
        
        manager.viewDidLoad()
        XCTAssertEqual(manager.page, 1)
        manager.refresh()
        XCTAssertEqual(manager.page, 1)
        manager.nextPage()
        XCTAssertEqual(manager.page, 2)
        manager.nextPage()
        XCTAssertEqual(manager.page, 3)
        
        XCTAssert(wasCalled)
        XCTAssertEqual(callCount, 3)
    }

    func testRefreshAfterNextPage() {
        var wasCalled = false
        
        let manager = LUXPageableModelManager(call, firstPageValue: 1)
        
        call.firingFunc = { _ in
            wasCalled = true
        }
        
        manager.viewDidLoad()
        
        manager.refresh()
        XCTAssertEqual(manager.page, 1)
        manager.nextPage()
        XCTAssertEqual(manager.page, 2)
        manager.refresh()
        XCTAssertEqual(manager.page, 1)
        XCTAssert(wasCalled)
    }

}
