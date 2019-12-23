//
//  THUXAppOpenFlowController.swift
//  ThryvUXComponents
//
//  Created by Elliot Schrock on 4/30/18.
//

import UIKit

open class LUXAppOpenFlowController: LUXFlowCoordinator {
    open var splashViewModel: LUXSplashViewModel?
    open var loginViewModel: LUXLoginViewModel?
    open var registrationViewModel: LUXRegistrationViewModel?
    
    public init() {}
    open func initialVC() -> UIViewController? { return nil }
}
