//
//  LUXSplitFlowController.swift
//  LUX
//
//  Created by Elliot Schrock on 9/3/20.
//

import Foundation

open class LUXSplitFlowController<T, U>: LUXFlowCoordinator, UISplitViewControllerDelegate where T: LUXFlowCoordinator, U: LUXFlowCoordinator {
    public var leftFC: T!
    public var rightFC: U!
    
    open func initialVC() -> UIViewController? {
        let splitVC = UISplitViewController()
        splitVC.delegate = self
        splitVC.preferredDisplayMode = .allVisible
        splitVC.viewControllers = viewControllers()
        return splitVC
    }
    
    open func viewControllers() -> [UIViewController] { return [UIViewController]() }
    
    open func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}

public extension UIViewController {
    func splitIsCollapsed() -> Bool {
        return splitViewController!.isCollapsed
    }
    
    func detailVC<T>() -> T? {
        if let split = splitViewController {
            let controllers = split.viewControllers
            return (controllers[controllers.count-1] as! UINavigationController).topViewController as? T
        }
        return nil
    }
}
