//
//  LUXLandingViewController.swift
//  LUX
//
//  Created by Elliot Schrock on 4/2/20.
//

import UIKit

open class LUXLandingViewController: LUXFunctionalViewController {
    @IBOutlet open weak var backgroundImageView: UIImageView!
    @IBOutlet open weak var logoImageView: UIImageView!
    @IBOutlet open weak var loginButton: UIButton!
    @IBOutlet open weak var signUpButton: UIButton!
    
    @IBAction @objc open func loginPressed() {}
    
    @IBAction @objc open func signUpPressed() {}
}
