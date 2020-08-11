//
//  LUXSplashBaseProtocols.swift
//  LUX
//
//  Created by Elliot Schrock on 7/9/20.
//

import Foundation

public protocol LUXSplashTask {
    func execute(completion: @escaping () -> Void)
}

public protocol LUXSplashInputs {
    func viewDidLoad()
    func viewWillAppear()
    func viewDidAppear()
}

