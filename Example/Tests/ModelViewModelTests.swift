//
//  ModelViewModelTests.swift
//  LUX_Tests
//
//  Created by Elliot Schrock on 12/10/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
@testable import LUX
import Combine

class ModelViewModelTests: XCTestCase {
    func testModels() {
        var wasCalled = false
        let subject = PassthroughSubject<[Human], Never>()
        let vm = LUXModelCallViewModel(modelsPublisher: subject.eraseToAnyPublisher())
        let cancel = vm.$models.sinkThrough { _ in
            wasCalled = true
        }
        subject.send([Human]())
        XCTAssert(wasCalled)
        cancel.cancel()
    }
}
