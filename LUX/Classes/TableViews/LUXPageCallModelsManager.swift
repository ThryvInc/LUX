//
//  LUXPageCallModelsManager.swift
//  LithoUXComponents
//
//  Created by Elliot Schrock on 10/6/19.
//

import Combine

open class LUXPageCallModelsManager<T>: LUXPageableModelManager where T: Decodable {
    @Published public var models = [T]()
    private var cancel: AnyCancellable?
    
    public init(_ call: CombineNetCall, _ modelArrayPublisher: AnyPublisher<[T], Never>, firstPageValue: Int = 1) {
        super.init(call, firstPageValue: firstPageValue)
        
        cancel = modelArrayPublisher.sink { [weak self] (array) in
            if self?.page == firstPageValue {
                self?.models = array
            } else {
                if var allModels = self?.models {
                    allModels.append(contentsOf: array)
                    self?.models = allModels
                }
            }
        }
    }
    
    public override init(_ call: CombineNetCall, firstPageValue: Int = 1) {
        super.init(call, firstPageValue: firstPageValue)
        
        if let modelsPublisher: AnyPublisher<[T], Never> = optModelPublisher(from: call.responder?.$data.eraseToAnyPublisher()) {
            cancel = modelsPublisher.sink { [weak self] array in
                if self?.page == firstPageValue {
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
}
