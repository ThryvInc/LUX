//
//  LUXModelCallViewModel.swift
//  ThryvUXComponents
//
//  Created by Elliot Schrock on 7/23/18.
//

import UIKit
import FlexDataSource
import Prelude
import Combine

open class LUXModelCallViewModel<T> {
    @Published public var models = [T]()
    public var cancelBag = Set<AnyCancellable?>()
    
    public init(modelsPublisher: AnyPublisher<[T], Never>) {
        cancelBag.insert(modelsPublisher.sink { [weak self] models in self?.models = models })
    }
}
