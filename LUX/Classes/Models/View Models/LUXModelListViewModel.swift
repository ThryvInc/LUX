//
//  THUXModelListViewModel.swift
//  ThryvUXComponents
//
//  Created by Elliot Schrock on 7/18/18.
//

import UIKit
import MultiModelTableViewDataSource
import Prelude
import Combine

public protocol LUXDataSourceProvider {
    var dataSource: MultiModelTableViewDataSource { get }
}

open class LUXModelListViewModel<T>: LUXModelTableViewModel<T>, LUXDataSourceProvider {
    public let dataSource: MultiModelTableViewDataSource
    
    public override init(modelsPublisher: AnyPublisher<[T], Never>, modelToItem: @escaping (T) -> MultiModelTableViewDataSourceItem) {
        dataSource = MultiModelTableViewDataSource()
        super.init(modelsPublisher: modelsPublisher, modelToItem: modelToItem)
        
        cancelBag.insert(self.sectionsPublisher.sink {
            self.dataSource.sections = $0
            self.dataSource.tableView?.reloadData()
        })
    }
}

open class LUXFilteredModelListViewModel<T>: LUXModelListViewModel<T> {
    public init(modelsPublisher: AnyPublisher<[T], Never>, filter: @escaping (T) -> Bool, modelToItem: @escaping (T) -> MultiModelTableViewDataSourceItem) {
        super.init(modelsPublisher: modelsPublisher.map { $0.filter(filter) }.eraseToAnyPublisher(), modelToItem: modelToItem)
    }
}
