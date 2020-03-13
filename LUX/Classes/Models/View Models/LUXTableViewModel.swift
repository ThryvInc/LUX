//
//  LUXTableViewModel.swift
//  LUX
//
//  Created by Elliot Schrock on 3/9/20.
//

import UIKit
import Combine
import MultiModelTableViewDataSource
import Prelude

open class LUXTableViewModel {
    public var cancelBag = Set<AnyCancellable?>()
    public var dataSource: UITableViewDataSource? { didSet { didSetDataSource() }}
    public var tableDelegate: UITableViewDelegate? { didSet { didSetTableDelegate() }}
    
    public var tableView: UITableView? { didSet { configureTableView() }}
    
    open func didSetDataSource() { configureTableView() }
    open func didSetTableDelegate() { configureTableView() }
    open func configureTableView() {
        tableView?.dataSource = dataSource
        if let ds = dataSource as? MultiModelTableViewDataSource {
            ds.tableView = tableView
        }
        tableView?.delegate = tableDelegate
    }
}

open class LUXRefreshableTableViewModel: LUXTableViewModel, Refreshable {
    public var refresher: Refreshable
    
    public init(_ refresher: Refreshable) {
        self.refresher = refresher
    }
    
    @objc open func refresh() {
        if let isRefreshing = tableView?.refreshControl?.isRefreshing, !isRefreshing {
            tableView?.refreshControl?.beginRefreshing()
        }
        refresher.refresh()
    }
    
    @objc open func endRefreshing() {
        tableView?.refreshControl?.endRefreshing()
    }
    
    open override func configureTableView() {
        super.configureTableView()
        
        tableView?.refreshControl = UIRefreshControl()
        tableView?.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
}
extension LUXRefreshableTableViewModel {
    public func setupEndRefreshing(from call: CombineNetCall) {
        cancelBag.insert(call.responder?.$data.sink { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.endRefreshing()
            }
        })
        
        cancelBag.insert(call.responder?.$error.sink { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.endRefreshing()
            }
        })
        
        cancelBag.insert(call.responder?.$serverError.sink { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.endRefreshing()
            }
        })
        
    }
}

open class LUXItemsTableViewModel: LUXRefreshableTableViewModel {
    public var sectionsPublisher: AnyPublisher<[MultiModelTableViewDataSourceSection], Never>
    
    public init(_ refresher: Refreshable, itemsPublisher: AnyPublisher<[MultiModelTableViewDataSourceItem], Never>) {
        let toSections = itemsToSection >>> arrayOfSingleObject
        sectionsPublisher = itemsPublisher.map(toSections).eraseToAnyPublisher()
        
        super.init(refresher)
        
        let dataSource = MultiModelTableViewDataSource()
        cancelBag.insert(self.sectionsPublisher.sink {
            dataSource.sections = $0
            dataSource.tableView?.reloadData()
        })
        self.dataSource = dataSource
    }
}
