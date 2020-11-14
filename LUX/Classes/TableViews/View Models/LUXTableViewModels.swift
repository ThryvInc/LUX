//
//  LUXTableViewModels.swift
//  LUX
//
//  Created by Elliot Schrock on 3/9/20.
//

import UIKit
import fuikit
import Combine
import FunNet
import Slippers
import FlexDataSource
import Prelude
import LithoOperators

open class LUXRefreshableTableViewModel: LUXTableViewModel, Refreshable {
    public var cancelBag = Set<AnyCancellable>()
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
        setupEndRefreshing(from: call.publisher)
    }
    
    public func setupEndRefreshing(from publisher: CombineNetworkResponder) {
        publisher.$data.sink { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.endRefreshing()
            }
        }.store(in: &cancelBag)
        
        publisher.$error.sink { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.endRefreshing()
            }
        }.store(in: &cancelBag)
        
        publisher.$serverError.sink { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.endRefreshing()
            }
        }.store(in: &cancelBag)
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

public func pageableTableViewModel<T, U, C>(_ call: CombineNetCall,
                                     modelUnwrapper: @escaping (T) -> [U],
                                     _ configurer: @escaping (U, C) -> Void,
                                     _ onTap: @escaping (U) -> Void)
    -> LUXItemsTableViewModel where T: Decodable, U: Decodable, C: UITableViewCell {
        let dataPub = call.publisher.$data.eraseToAnyPublisher()
        let modelPub = unwrappedModelPublisher(from: dataPub, modelUnwrapper)
        let pageManager = LUXPageCallModelsManager(call, modelPub)
        let modelToItem = configurer >||> LUXModelItem<U, C>.init
        let modelsToItems = modelToItem >||> map
        let itemsPub: AnyPublisher<[FlexDataSourceItem], Never> = pageManager.$models.dropFirst().map(modelsToItems).eraseToAnyPublisher()
        let vm = LUXItemsTableViewModel(pageManager, itemsPublisher: itemsPub)
        if let ds = vm.dataSource as? FlexDataSource {
            let delegate = FUITableViewDelegate()
            delegate.onWillDisplay = pageManager.willDisplayFunction()
            delegate.onSelect = ds.itemTapOnSelect(onTap: (optionalCast >?> ^\LUXModelItem<U, C>.model) >?> onTap)
            vm.tableDelegate = delegate
        }
        vm.setupEndRefreshing(from: call)
        return vm
}

public func pageableTableViewModel<U, C>(_ call: CombineNetCall,
                                     _ configurer: @escaping (U, C) -> Void,
                                     _ onTap: @escaping (U) -> Void)
    -> LUXItemsTableViewModel where U: Decodable, C: UITableViewCell {
        let dataPub = call.publisher.$data.eraseToAnyPublisher()
        let modelPub: AnyPublisher<[U], Never> = modelPublisher(from: dataPub)
        let pageManager = LUXPageCallModelsManager(call, modelPub)
        let modelToItem = configurer >||> LUXModelItem<U, C>.init
        let modelsToItems = modelToItem >||> map
        let itemsPub: AnyPublisher<[FlexDataSourceItem], Never> = pageManager.$models.dropFirst().map(modelsToItems).eraseToAnyPublisher()
        let vm = LUXItemsTableViewModel(pageManager, itemsPublisher: itemsPub)
        if let ds = vm.dataSource as? FlexDataSource {
            let delegate = FUITableViewDelegate()
            delegate.onWillDisplay = pageManager.willDisplayFunction()
            delegate.onSelect = ds.itemTapOnSelect(onTap: (optionalCast >?> ^\LUXModelItem<U, C>.model) >?> onTap)
            vm.tableDelegate = delegate
        }
        vm.setupEndRefreshing(from: call)
        return vm
}

public func refreshableTableViewModel<T, U, C>(_ call: CombineNetCall,
                                        modelUnwrapper: @escaping (T) -> [U],
                                        _ configurer: @escaping (U, C) -> Void,
                                        _ onTap: @escaping (U) -> Void)
    -> LUXItemsTableViewModel where T: Decodable, U: Decodable, C: UITableViewCell {
        let dataPub = call.publisher.$data.eraseToAnyPublisher()
        let modelPub = unwrappedModelPublisher(from: dataPub, modelUnwrapper)
        let refreshManager = LUXRefreshableNetworkCallManager(call)
        let modelToItem = configurer >||> LUXModelItem<U, C>.init
        let modelsToItems = modelToItem >||> map
        let itemsPub: AnyPublisher<[FlexDataSourceItem], Never> = modelPub.map(modelsToItems).eraseToAnyPublisher()
        let vm = LUXItemsTableViewModel(refreshManager, itemsPublisher: itemsPub)
        if let ds = vm.dataSource as? FlexDataSource {
            let delegate = FUITableViewDelegate()
            delegate.onSelect = ds.itemTapOnSelect(onTap: (optionalCast >?> ^\LUXModelItem<U, C>.model) >?> onTap)
            vm.tableDelegate = delegate
        }
        vm.setupEndRefreshing(from: call)
        return vm
}

public func refreshableTableViewModel<U, C>(_ call: CombineNetCall,
                                        _ configurer: @escaping (U, C) -> Void,
                                        _ onTap: @escaping (U) -> Void)
    -> LUXItemsTableViewModel where U: Decodable, C: UITableViewCell {
        let dataPub = call.publisher.$data.eraseToAnyPublisher()
        let modelPub: AnyPublisher<[U], Never> = modelPublisher(from: dataPub)
        let refreshManager = LUXRefreshableNetworkCallManager(call)
        let modelToItem = configurer >||> LUXModelItem<U, C>.init
        let modelsToItems = modelToItem >||> map
        let itemsPub: AnyPublisher<[FlexDataSourceItem], Never> = modelPub.map(modelsToItems).eraseToAnyPublisher()
        let vm = LUXItemsTableViewModel(refreshManager, itemsPublisher: itemsPub)
        if let ds = vm.dataSource as? FlexDataSource {
            let delegate = FUITableViewDelegate()
            delegate.onSelect = ds.itemTapOnSelect(onTap: (optionalCast >?> ^\LUXModelItem<U, C>.model) >?> onTap)
            vm.tableDelegate = delegate
        }
        vm.setupEndRefreshing(from: call)
        return vm
}
