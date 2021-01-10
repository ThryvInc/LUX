//
//  SplashViewModelTests.swift
//  LUX_Tests
//
//  Created by Elliot Schrock on 12/22/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
@testable import LUX
@testable import FunNet

class SplashViewModelTests: XCTestCase {
    
    func testViewDidLoads() {
        
        class MyViewModel: LUXSplashViewModel {
            var loadCalled = false
            var didAppearCalled = false
            var willAppearCalled = false
            override func viewDidLoad() {
                self.loadCalled = true
            }
            override func viewDidAppear() {
                self.didAppearCalled = true
            }
            override func viewWillAppear() {
                self.willAppearCalled = true
            }
        }
        
        let vm = MyViewModel(minimumVisibleTime: 10, nil, nil, otherTasks: nil)
        XCTAssertEqual(vm.semaphore, 2)
        vm.viewDidLoad()
        vm.viewDidAppear()
        vm.viewWillAppear()
        XCTAssertTrue(vm.loadCalled)
        XCTAssertTrue(vm.didAppearCalled)
        XCTAssertTrue(vm.willAppearCalled)
    }

    func testAdvanceAuthed() {
        
    }

}
