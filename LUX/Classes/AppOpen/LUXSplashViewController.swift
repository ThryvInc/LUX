//
//  LUXSplashViewController.swift
//  ThryvUXComponents
//
//  Created by Elliot Schrock on 2/10/18.
//

import UIKit
import fuikit

open class LUXSplashViewController: FUIViewController {
    @IBOutlet open weak var logoTopConstraint: NSLayoutConstraint?
    @IBOutlet open weak var bgImageView: UIImageView?
    @IBOutlet open weak var logoImageView: UIImageView?
    @IBOutlet open weak var activityIndicator: UIActivityIndicatorView?
    
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
