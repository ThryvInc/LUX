//
//  LUXNetCallsRefresher.swift
//  LUX
//
//  Created by Elliot Schrock on 7/9/20.
//

import Foundation
import Prelude
import LithoOperators
import FunNet
import Slippers

open class LUXNetCallsRefresher: MetaRefresher {
    open var calls: [Fireable]
    
    public init(_ calls: Fireable...) {
        self.calls = calls
        super.init(calls.map { Refresher($0.fire) })
    }
}
