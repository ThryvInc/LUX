//
//  LUXSplashViewController.swift
//  ThryvUXComponents
//
//  Created by Elliot Schrock on 2/10/18.
//

import UIKit

open class LUXSplashViewController: UIViewController {
    public var viewModel: LUXSplashProtocol?

    override open func viewDidLoad() {
        super.viewDidLoad()

        viewModel?.inputs.viewDidLoad()
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel?.inputs.viewWillAppear()
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel?.inputs.viewDidAppear()
    }

}
