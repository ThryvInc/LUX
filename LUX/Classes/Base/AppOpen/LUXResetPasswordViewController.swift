//
//  LUXResetPasswordViewController.swift
//  LithoUXComponents
//
//  Created by Elliot Schrock on 10/31/19.
//

import UIKit
import fuikit

open class LUXResetPasswordViewController: FUIViewController {
    @IBOutlet open weak var newPasswordTextField: UITextField?
    @IBOutlet open weak var confirmPasswordTextField: UITextField?
    @IBOutlet open weak var submitButton: UIButton?
    @IBOutlet open weak var activityIndicatorView: UIActivityIndicatorView?
    
    public var onSubmit: ((LUXResetPasswordViewController) -> Void)?

    @IBAction open func submitPressed() {
        onSubmit?(self)
    }
}
