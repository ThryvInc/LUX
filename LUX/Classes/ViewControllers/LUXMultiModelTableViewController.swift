//
//  THUXMultiModelTableViewController.swift
//  LithoUXComponents
//
//  Created by Elliot Schrock on 10/12/19.
//

import UIKit
import Combine

open class LUXMultiModelTableViewController<T>: LUXFunctionalViewController {
    @IBOutlet public var tableView: UITableView?
    open var tableViewDelegate: LUXTappableTableDelegate? { didSet { configureTableView() }}
    open var viewModel: T? { didSet { configureTableView() }}
    open var refreshableModelManager: LUXRefreshableNetworkCallManager? {
        didSet {
            if let call = refreshableModelManager?.call as? CombineNetCall {
                indicatingCall = call
            }
        }
    }
    open var indicatingCall: CombineNetCall? {
        didSet {
            cancelBag.insert(indicatingCall?.responder?.$response.sink { _ in
                self.tableView?.refreshControl?.endRefreshing()
            })
            cancelBag.insert(indicatingCall?.responder?.$data.sink { _ in
                self.tableView?.refreshControl?.endRefreshing()
            })
        }
    }
    var cancelBag = Set<AnyCancellable?>()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.rowHeight = UITableView.automaticDimension
        tableView?.tableFooterView = UIView()
        
        configureTableView()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }
    
    @objc
    open func refresh() {
        if let refresher = refreshableModelManager {
            if let isRefreshing = tableView?.refreshControl?.isRefreshing, !isRefreshing {
                tableView?.refreshControl?.beginRefreshing()
            }
            refresher.refresh()
        }
    }

    open func configureTableView() {
        if let vm = viewModel as? LUXDataSourceProvider {
            vm.dataSource.tableView = tableView
            tableView?.dataSource = vm.dataSource
        }
        if let pageableModelManager = refreshableModelManager as? LUXPageableModelManager {
            pageableModelManager.viewDidLoad()
        }
        tableView?.delegate = tableViewDelegate
        
        tableView?.refreshControl = UIRefreshControl()
        tableView?.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
}
