//
//  SplitFlowControllerTests.swift
//  LUX_Tests
//
//  Created by Calvin Collins on 1/10/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
@testable import LUX

class MyFlowCoordinator: LUXFlowCoordinator {
    var tag: Int?
    public var initialViewController: UIViewController? { initialVC() }
    func initialVC() -> UIViewController? {
        let vc = UIViewController()
        guard let tag = tag else { return nil }
        vc.view.tag = tag
        return vc
    }
}

class MyFlowNavCoordinator: LUXFlowCoordinator {
    public var initialViewController: UIViewController? { initialVC() }
    let navigationController: UINavigationController
    func initialVC() -> UIViewController? {
        return navigationController.topViewController
    }
    
    public init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

class MySplitFlowController: LUXSplitFlowController<MyFlowCoordinator, MyFlowCoordinator> {
    
    override func viewControllers() -> [UIViewController] {
        return [leftFC.initialVC(), rightFC.initialVC()].filter { $0 != nil }.map({ $0! })
    }
    
    
}

class SplitFlowControllerTests: XCTestCase {

    func testSplitFlowController() {
        let coordinator = MySplitFlowController()
        let subCoordinatorLeft = MyFlowCoordinator()
        subCoordinatorLeft.tag = 0
        let subCoordinatorRight = MyFlowCoordinator()
        subCoordinatorRight.tag = 1
        coordinator.leftFC = subCoordinatorLeft
        coordinator.rightFC = subCoordinatorRight
        XCTAssertEqual(coordinator.viewControllers().count, 2)
        XCTAssertTrue(coordinator.splitViewController(UISplitViewController(), collapseSecondary: subCoordinatorRight.initialVC()!, onto: subCoordinatorLeft.initialVC()!))
        XCTAssertNotNil(coordinator.initialVC())
        
        guard let _ = coordinator.initialVC() else { return XCTFail("Could not instantiate") }
        XCTAssert((coordinator.initialVC() as! UISplitViewController).viewControllers.count != 0)
        XCTAssertTrue(!(coordinator.initialVC() as! UISplitViewController).viewControllers[0].splitIsCollapsed())
    }
    
    func testDefaultSplitFlowController() {
        let subCoordinatorLeft = MyFlowCoordinator()
        let vc = UIViewController()
        let nav = UINavigationController(rootViewController: vc)
        let subCoordinatorRight = MyFlowNavCoordinator(nav)
        let coordinator = LUXSplitFlowController<MyFlowCoordinator, MyFlowNavCoordinator>()
        coordinator.leftFC = subCoordinatorLeft
        coordinator.rightFC = subCoordinatorRight
        
        XCTAssertEqual(coordinator.viewControllers().count, 0)
        
        
    }

}
