//
//  THUXResetPasswordViewController.swift
//  LithoUXComponents
//
//  Created by Elliot Schrock on 10/31/19.
//

import UIKit

open class THUXResetPasswordViewController: LUXFunctionalViewController {
    @IBOutlet open weak var newPasswordTextField: UITextField?
    @IBOutlet open weak var confirmPasswordTextField: UITextField?
    @IBOutlet open weak var submitButton: UIButton?
    @IBOutlet open weak var activityIndicatorView: UIActivityIndicatorView?
    
    public var onSubmit: ((THUXResetPasswordViewController) -> Void)?

    @IBAction open func submitPressed() {
        onSubmit?(self)
    }
}
