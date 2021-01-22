//
//  LUXFlowCoordinator.swift
//  LithoUXComponents
//
//  Created by Elliot Schrock on 9/11/19.
//

import UIKit

public protocol LUXFlowCoordinator: class {
    var initialViewController: UIViewController? { get }
    func initialVC() -> UIViewController?
}
