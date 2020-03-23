//
//  LUXMetaRefresher.swift
//  LUX
//
//  Created by Elliot Schrock on 3/9/20.
//

import Foundation

open class LUXMetaRefresher: Refreshable {
    open var refreshers: [Refreshable]
    
    public init(_ refreshers: Refreshable...) {
        self.refreshers = refreshers
    }
    
    public func refresh() {
        refreshers.forEach { $0.refresh() }
    }
}
