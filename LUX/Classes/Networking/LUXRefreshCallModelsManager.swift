//
//  LUXRefreshCallModelsManager.swift
//  FunNet
//
//  Created by Elliot Schrock on 10/12/19.
//

import Combine
import FunNet

open class LUXRefreshCallModelsManager<T>: LUXRefreshableNetworkCallManager where T: Decodable {
    @Published public var models = [T]()
    private var cancellable: AnyCancellable?
    public init(_ call: CombineNetCall, _ modelArrayPublisher: AnyPublisher<[T], Never>) {
        super.init(call)
        cancellable = modelArrayPublisher.sink { [weak self] models in
            self?.models = models
        }
    }
}
