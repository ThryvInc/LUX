//
//  LUXFunctionalViewController.swift
//  LithoUXComponents
//
//  Created by Elliot Schrock on 10/31/19.
//

import UIKit

open class LUXFunctionalViewController: UIViewController {
    public var onLoadView: ((LUXFunctionalViewController) -> Void)?
    public var onViewDidLoad: ((LUXFunctionalViewController) -> Void)?
    public var onViewWillAppear: ((LUXFunctionalViewController, Bool) -> Void)?
    public var onViewDidAppear: ((LUXFunctionalViewController, Bool) -> Void)?
    public var onViewWillDisappear: ((LUXFunctionalViewController, Bool) -> Void)?
    public var onViewDidDisappear: ((LUXFunctionalViewController, Bool) -> Void)?
    
    open override func loadView() {
        onLoadView?(self)
        super.loadView()
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        onViewDidLoad?(self)
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onViewWillAppear?(self, animated)
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        onViewDidAppear?(self, animated)
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        onViewWillDisappear?(self, animated)
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        onViewDidDisappear?(self, animated)
    }
}
