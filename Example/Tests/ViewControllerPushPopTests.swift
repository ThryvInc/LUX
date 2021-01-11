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
    
    func testTabBarFunctions() {
        let vc = UIViewController()
        vc.view.tag = 0
        let vc2 = UIViewController()
        vc2.view.tag = 1
        let tab = UITabBarController()
        tab.setViewControllers([vc, vc2], animated: true)
        let nav = UINavigationController(rootViewController: tab)
        XCTAssertEqual(vc.tabContainer(), tab, "Tab container is not equal")
        
        let vc3 = UIViewController()
        vc2.tabPushAnimated(vc3)
        
        vc2.tabPopAnimated()
        
        vc2.tabPresentAnimated(vc3)
        
        vc2.tabDismissAnimated(vc3)
    }
    
    func testPushPopClosures() {
        let vc = UIViewController()
        let nav = UINavigationController(rootViewController: vc)
        let vc2 = UIViewController()
        
        let push = vc.pushClosure()
        push(vc2)
        
        let pop = vc.popClosure()
        pop()
        
        let present = vc.presentClosure()
        present(vc2)
        
        let dismiss = vc.dismissClosure()
        dismiss({ })
    }
    
    func testTabPushPopClosures() {
        let vc = UIViewController()
        vc.view.tag = 0
        let vc2 = UIViewController()
        vc2.view.tag = 1
        let tab = UITabBarController()
        tab.setViewControllers([vc, vc2], animated: true)
        let nav = UINavigationController(rootViewController: tab)
        let vc3 = UIViewController()
        
        let push = vc3.tabPushClosure()
        push(vc3)
        
        let pop = vc3.tabPopClosure()
        pop()
        
        let present = vc3.tabPresentClosure()
        present(vc3)
    }
    
    func testFreeFuncTabPushPop() {
        let vc = UIViewController()
        vc.view.tag = 0
        let vc2 = UIViewController()
        vc2.view.tag = 1
        let tab = UITabBarController()
        tab.setViewControllers([vc, vc2], animated: true)
        let nav = UINavigationController(rootViewController: tab)
        let vc3 = UIViewController()
        
        tabPushAnimated(vc2, vc3)
        tabPopAnimated(vc2)
        
        tabPresentAnimated(vc2, vc3)
    }

}
