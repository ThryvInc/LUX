//
//  Configure.swift
//  LUX
//
//  Created by Elliot Schrock on 12/23/19.
//

import Foundation

public protocol Configure {}

public extension Configure {
    
    /// Makes it available to set properties with closures just after initializing.
    ///
    ///     let frame = UIView().configure {
    ///       $0.backgroundColor = .red
    ///     }
    func configure(_ block: (inout Self) -> Void) -> Self {
        var copy = self
        block(&copy)
        return copy
    }
}

