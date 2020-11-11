//
//  LUXRefreshableModelManager.swift
//  ThryvUXComponents
//
//  Created by Elliot Schrock on 2/11/18.
//

import FunNet
import Slippers

public protocol CallManager {
    var call: Fireable? { get set }
}

open class LUXRefreshableNetworkCallManager: Refresher, CallManager {
    open var call: Fireable?
    
    public init(_ call: Fireable) {
        super.init(call.fire)
        self.call = call
    }
}
