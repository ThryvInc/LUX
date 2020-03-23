//
//  LUXRefreshableModelManager.swift
//  ThryvUXComponents
//
//  Created by Elliot Schrock on 2/11/18.
//

import UIKit
import FunNet

public protocol Refreshable {
    func refresh()
}

open class LUXRefreshableNetworkCallManager: Refreshable {
    open var call: Fireable?
    
    public init(_ call: Fireable) {
        self.call = call
    }
    
    open func refresh() {
        call?.fire()
    }
    
}
