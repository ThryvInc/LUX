//
//  LUXRefreshableModelManager.swift
//  ThryvUXComponents
//
//  Created by Elliot Schrock on 2/11/18.
//

import FunNet

open class LUXRefreshableNetworkCallManager: Refreshable {
    open var call: Fireable?
    
    public init(_ call: Fireable) {
        self.call = call
    }
    
    open func refresh() {
        call?.fire()
    }
    
}
