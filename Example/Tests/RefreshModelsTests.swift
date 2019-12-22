//
//  RefreshModelsTests.swift
//  LUX_Tests
//
//  Created by Elliot Schrock on 12/8/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
@testable import LUX
@testable import FunNet
import Combine

class RefreshModelsTests: XCTestCase {
    var call: CombineNetCall = CombineNetCall(configuration: ServerConfiguration(host: "lithobyte.co", apiRoute: "api/v1"), Endpoint())

    override func setUp() {
        call.firingFunc = { netCall in
            if let responder = netCall.responder {
                responder.data = firstPageOfHumans.data(using: .utf8)
            }
        }
    }

    func testRefreshModels() {
        if let responder = call.responder {
            var wasCalled = false
            let modelsPub: AnyPublisher<[Human], Never> = modelPublisher(from: responder.$data.eraseToAnyPublisher())
            let manager = LUXRefreshCallModelsManager(call, modelsPub)
            let cancel = manager.$models.sinkThrough { humans in
                XCTAssertEqual(humans.count, 1)
                wasCalled = true
            }
            manager.refresh()
            XCTAssert(wasCalled)
            cancel.cancel()
        } else {
            XCTFail()
        }
    }
}
