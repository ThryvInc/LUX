//
//  PagingManagerTests.swift
//  LithoUXComponents_Tests
//
//  Created by Elliot Schrock on 10/8/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
@testable import LUX
@testable import FunNet

class PagingModelsTests: XCTestCase {
    var call: CombineNetCall = CombineNetCall(configuration: ServerConfiguration(host: "lithobyte.co", apiRoute: "api/v1"), Endpoint())

    override func setUp() {
        call.firingFunc = { netCall in
            if let page: Int = netCall.endpoint.getParams["page"] as? Int, let responder = netCall.responder {
                switch page {
                    case 1:
                        responder.data = firstPageOfHumans.data(using: .utf8)
                        break
                    case 2:
                        responder.data = secondPageOfHumans.data(using: .utf8)
                        break
                    case 3:
                        responder.data = thirdPageOfHumans.data(using: .utf8)
                        break
                default:
                    XCTFail()
                }
            }
        }
    }
    
    func testPageNotCalledOnViewLoad() {
        var wasCalled = false
        
        let pageManager = LUXPageCallModelsManager<Human>(call, firstPageValue: 1)
        let cancel = pageManager.$models.sinkThrough { (humans) in
            print("was called")
            wasCalled = true
        }
        pageManager.viewDidLoad()
        XCTAssert(!wasCalled)
        
        pageManager.refresh()
        XCTAssert(wasCalled)
        
        cancel.cancel()
    }

    func testRefresh() {
        var wasCalled = false
        
        let pageManager = LUXPageCallModelsManager<Human>(call, firstPageValue: 1)
        let cancel = pageManager.$models.sinkThrough { (humans) in
            XCTAssertEqual(humans.count, 1)
            XCTAssertEqual(humans.first?.id, 1)
            wasCalled = true
        }
        pageManager.viewDidLoad()
        pageManager.refresh()
        
        XCTAssert(wasCalled)
        cancel.cancel()
    }

    func testNextPage() {
        var callCount = 0
        let pageManager = LUXPageCallModelsManager<Human>(call, firstPageValue: 1)
        let cancel = pageManager.$models.sinkThrough { (humans) in
            callCount += 1
                print("next callCount: \(callCount)")
            if callCount == 2 {
                XCTAssertEqual(humans.count, 2)
                XCTAssertEqual(humans.first?.id, 1)
                if humans.count > 1 {
                    XCTAssertEqual(humans[1].id, 2)
                }
            }
            if callCount == 3 {
                XCTAssertEqual(humans.count, 3)
                XCTAssertEqual(humans.first?.id, 1)
                if humans.count > 1 {
                    XCTAssertEqual(humans[1].id, 2)
                }
                if humans.count > 2 {
                    XCTAssertEqual(humans[2].id, 3)
                }
            }
        }
        print("start next")
        pageManager.viewDidLoad()
        print("next refresh")
        pageManager.refresh()
        pageManager.nextPage()
        pageManager.nextPage()
        
        XCTAssertEqual(callCount, 3)
        cancel.cancel()
    }

    func testRefreshAfterNextPage() {
        var callCount = 0
        let pageManager = LUXPageCallModelsManager<Human>(call, firstPageValue: 1)
        let cancel = pageManager.$models.sinkThrough { (humans) in
            callCount += 1
            if callCount == 2 {
                XCTAssertEqual(humans.count, 2)
                XCTAssertEqual(humans.first?.id, 1)
                if humans.count > 1 {
                    XCTAssertEqual(humans[1].id, 2)
                }
            }
            if callCount == 3 {
                XCTAssertEqual(humans.count, 1)
                XCTAssertEqual(humans.first?.id, 1)
            }
        }
        pageManager.viewDidLoad()
        pageManager.refresh()
        pageManager.nextPage()
        pageManager.refresh()
        
        XCTAssertEqual(callCount, 3)
        cancel.cancel()
    }
}
