//
//  LUXPageCallModelsManager.swift
//  LithoUXComponents
//
//  Created by Elliot Schrock on 10/6/19.
//

import FunNet
import Combine
import Prelude
import LithoOperators

open class LUXPageCallModelsManager<T>: LUXCallPager where T: Decodable {
    @Published public var models = [T]()
    private var cancel: AnyCancellable?
    
    public init(pageKeyName: String = "page",
                countKeyName: String = "count",
                defaultCount: Int = 20,
                firstPageValue: Int = 1,
                _ call: CombineNetCall?,
                _ modelArrayPublisher: AnyPublisher<[T], Never>) {
        super.init(pageKeyName: pageKeyName, countKeyName: countKeyName, defaultCount: defaultCount, firstPageValue: firstPageValue, call)
        
        modelArrayPublisher |> subscribeForPaging
    }
    
    public init(pageKeyName: String = "page",
                countKeyName: String = "count",
                defaultCount: Int = 20,
                firstPageValue: Int = 1,
                _ call: CombineNetCall) {
        super.init(pageKeyName: pageKeyName, countKeyName: countKeyName, defaultCount: defaultCount, firstPageValue: firstPageValue, call)
        
        optModelPublisher(from: call.responder?.$data.eraseToAnyPublisher()) ?> subscribeForPaging
    }
    
    open func subscribeForPaging(_ modelsPublisher: AnyPublisher<[T], Never>) {
        cancel = modelsPublisher.sink { [weak self] array in
            if self?.page == self?.firstPageValue {
                self?.models = array
            } else {
                if var allModels = self?.models {
                    allModels.append(contentsOf: array)
                    self?.models = allModels
                }
            }
        }
    }
}
