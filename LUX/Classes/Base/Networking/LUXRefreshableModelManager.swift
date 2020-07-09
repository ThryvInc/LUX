//
//  LUXRefreshableModelManager.swift
//  ThryvUXComponents
//
//  Created by Elliot Schrock on 2/11/18.
//

import FunNet
import Slippers

open class LUXRefreshableNetworkCallManager: Refresher {
    open var call: Fireable?
    
    public init(_ call: Fireable) {
        super.init(call.fire)
        self.call = call
    }
}
