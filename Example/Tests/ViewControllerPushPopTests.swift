//
//  ViewControllerPushPopTests.swift
//  LUX_Tests
//
//  Created by Calvin Collins on 1/1/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
@testable import LUX
class ViewControllerPushPopTests: XCTestCase {

    func testPush() {
        let vc = UIViewController()
        vc.view.tag = 0
        let vc2 = UIViewController()
        vc2.view.tag = 1
        
        let nav = UINavigationController(rootViewController: vc)
        vc.pushAnimated(vc2)
        print(nav.viewControllers)
        vc.popAnimated()
        print(nav.viewControllers)
        XCTAssert(nav.viewControllers.count == 1)
        XCTAssert(nav.viewControllers[0].view.tag == 0)
        
        vc.presentAnimated(vc2)
        
        vc2.dismissAnimated(nil)
    }
    
    func testFreeFuncPush() {
        let vc = UIViewController()
        vc.view.tag = 0
        let vc2 = UIViewController()
        vc2.view.tag = 1
        
        let nav = UINavigationController(rootViewController: vc)
        pushAnimated(vc, vc2)
        popAnimated(vc)
        
        XCTAssert(nav.viewControllers.count == 1)
        XCTAssert(nav.viewControllers[0].view.tag == 0)
        
        presentAnimated(vc, vc2)
    }

}
