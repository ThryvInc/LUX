//
//  LUXCallRefresher.swift
//  LUX
//
//  Created by Elliot Schrock on 7/21/20.
//

import FunNet
import Slippers
import Combine

open class LUXCallRefresher: Refresher, NetworkFetcher {
    open var call: CombineNetCall?
    @Published open var isFetching = false
    open var cancelBag = Set<AnyCancellable>()
    
    public init(_ call: CombineNetCall) {
        super.init(call.fire)
        self.call = call
        
        call.publisher.$response.sink { [unowned self] _ in self.isFetching = false }.store(in: &cancelBag)
        call.publisher.$data.sink { [unowned self] _ in self.isFetching = false }.store(in: &cancelBag)
        call.publisher.$error.sink { [unowned self] _ in self.isFetching = false }.store(in: &cancelBag)
    }
    
    open override func refresh() {
        super.refresh()
        isFetching = true
    }
}
