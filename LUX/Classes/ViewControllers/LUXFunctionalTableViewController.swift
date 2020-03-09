//
//  LUXFunctionalTableViewController.swift
//  LUX
//
//  Created by Elliot Schrock on 3/9/20.
//

import UIKit

open class LUXFunctionalTableViewController: UIViewController {
    @IBOutlet public var tableView: UITableView?
    public var onLoadView: ((LUXFunctionalTableViewController) -> Void)?
    public var onViewDidLoad: ((LUXFunctionalTableViewController) -> Void)?
    public var onViewWillAppear: ((LUXFunctionalTableViewController, Bool) -> Void)?
    public var onViewDidAppear: ((LUXFunctionalTableViewController, Bool) -> Void)?
    public var onViewWillDisappear: ((LUXFunctionalTableViewController, Bool) -> Void)?
    public var onViewDidDisappear: ((LUXFunctionalTableViewController, Bool) -> Void)?
    
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
