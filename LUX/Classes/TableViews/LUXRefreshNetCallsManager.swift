//
//  LUXRefreshNetCallsManager.swift
//  LUX
//
//  Created by Elliot Schrock on 3/9/20.
//

import Foundation
import FunNet

open class LUXRefreshNetCallsManager: Refreshable {
    open var calls: [Fireable]
    
    public init(_ calls: Fireable...) {
        self.calls = calls
    }
    
    open func refresh() {
        calls.forEach { $0.fire() }
    }
}
