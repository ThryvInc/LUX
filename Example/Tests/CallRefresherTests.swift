//
//  CallRefresherTests.swift
//  LUX_Tests
//
//  Created by Calvin Collins on 12/27/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import FlexDataSource
import LithoOperators
@testable import LUX
import XCTest
import Prelude
import FunNet

let humans: [Human] = [Human(id: 123, name: "Calvin Collins"), Human(id: 123, name: "Elliot Schrock")]
let parseHuman: (Data) -> [Human]? = {
    return try? JSONDecoder().decode([Human].self, from: $0)
}
let encodeHuman: ([Human]) -> Data? = {
    return try? JSONEncoder().encode($0)
}
let json:String = String(data: encodeHuman(humans)!, encoding: .utf8)!

class CallRefresherTests: XCTestCase {
    func testRefresh() {
        let call: CombineNetCall = CombineNetCall(configuration: ServerConfiguration(host: "https://lithobyte.co", apiRoute: "/v1/api"), Endpoint())
        call.firingFunc = { $0.responder?.data = json.data(using: .utf8) }
        let refresher = LUXCallRefresher(call)
        XCTAssert(!refresher.isFetching)
        refresher.onRefresh = {
            XCTAssert(refresher.isFetching)
        }
    }
}
