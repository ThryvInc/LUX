//
//  LUXTableViewModel.swift
//  LUX
//
//  Created by Elliot Schrock on 3/9/20.
//

import UIKit
import Combine
import FunNet
import Slippers
import FlexDataSource
import Prelude
import LithoOperators

open class LUXTableViewModel {
    public var cancelBag = Set<AnyCancellable?>()
    public var dataSource: UITableViewDataSource? { didSet { didSetDataSource() }}
    public var tableDelegate: UITableViewDelegate? { didSet { didSetTableDelegate() }}
    
    public var tableView: UITableView? { didSet { configureTableView() }}
    
    open func didSetDataSource() { configureTableView() }
    open func didSetTableDelegate() { configureTableView() }
    open func configureTableView() {
        tableView?.dataSource = dataSource
        if let ds = dataSource as? FlexDataSource {
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

open class LUXSectionsTableViewModel: LUXRefreshableTableViewModel {
    public var sectionsPublisher: AnyPublisher<[FlexDataSourceSection], Never>
    
    public init(_ refresher: Refreshable,
                _ sectionsPublisher: AnyPublisher<[FlexDataSourceSection], Never>) {
        self.sectionsPublisher = sectionsPublisher
        
        super.init(refresher)
        
        let dataSource = FlexDataSource()
        cancelBag.insert(self.sectionsPublisher.sink {
            dataSource.sections = $0
            dataSource.tableView?.reloadData()
        })
        self.dataSource = dataSource
    }
}

open class LUXItemsTableViewModel: LUXSectionsTableViewModel {
    public init(_ refresher: Refreshable,
                itemsPublisher: AnyPublisher<[FlexDataSourceItem], Never>,
                toSections: @escaping ([FlexDataSourceItem]) -> [FlexDataSourceSection] = itemsToSection >>> arrayOfSingleObject) {
        super.init(refresher, itemsPublisher.map(toSections).eraseToAnyPublisher())
    }
}

func pageableTableViewModel<T, U, C>(_ call: CombineNetCall,
                                     modelUnwrapper: @escaping (T) -> [U],
                                     _ configurer: @escaping (U, C) -> Void,
                                     _ onTap: @escaping (U) -> Void)
    -> LUXItemsTableViewModel where T: Decodable, U: Decodable, C: UITableViewCell {
        let dataPub = call.publisher.$data.eraseToAnyPublisher()
        let modelPub = unwrappedModelPublisher(from: dataPub, modelUnwrapper)
        let pageManager = LUXPageCallModelsManager(call, modelPub)
        let modelToItem = configurer >||> LUXModelItem<U, C>.init
        let modelsToItems = modelToItem >||> map
        let itemsPub = pageManager.$models.dropFirst().map(modelsToItems).eraseToAnyPublisher()
        let vm = LUXItemsTableViewModel(pageManager, itemsPublisher: itemsPub.map { models in models.map { $0 as FlexDataSourceItem } }.eraseToAnyPublisher())
        if let ds = vm.dataSource as? FlexDataSource {
            let delegate = LUXFunctionalTableDelegate()
            delegate.onWillDisplay = pageManager.willDisplayFunction()
            delegate.onSelect = ds.itemTapOnSelect(onTap: (optionalCast(object:) >?> ^\LUXModelItem<U, C>.model) >>> (onTap >||> ifExecute))
            vm.tableDelegate = delegate
        }
        vm.setupEndRefreshing(from: call)
        return vm
}

func refreshableTableViewModel<T, U, C>(_ call: CombineNetCall,
                                        modelUnwrapper: @escaping (T) -> [U],
                                        _ configurer: @escaping (U, C) -> Void,
                                        _ onTap: @escaping (U) -> Void)
    -> LUXItemsTableViewModel where T: Decodable, U: Decodable, C: UITableViewCell {
        let dataPub = call.publisher.$data.eraseToAnyPublisher()
        let modelPub = unwrappedModelPublisher(from: dataPub, modelUnwrapper)
        let refreshManager = LUXRefreshableNetworkCallManager(call)
        let modelToItem = configurer >||> LUXModelItem<U, C>.init
        let modelsToItems = modelToItem >||> map
        let itemsPub = modelPub.map(modelsToItems).eraseToAnyPublisher()
        let vm = LUXItemsTableViewModel(refreshManager, itemsPublisher: itemsPub.map { models in models.map { $0 as FlexDataSourceItem } }.eraseToAnyPublisher())
        if let ds = vm.dataSource as? FlexDataSource {
            let delegate = LUXFunctionalTableDelegate()
            delegate.onSelect = ds.itemTapOnSelect(onTap: (optionalCast(object:) >?> ^\LUXModelItem<U, C>.model) >>> (onTap >||> ifExecute))
            vm.tableDelegate = delegate
        }
        vm.setupEndRefreshing(from: call)
        return vm
}
