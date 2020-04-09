//
//  Id.swift
//  LUX
//
//  Created by Elliot Schrock on 12/23/19.
//

import Foundation

public struct ID<Type>: Codable, Hashable {
    public let value: Int
    
    public init(value: Int) {
        self.value = value
    }

    public init(from decoder: Decoder) throws {
        value = try Int(from: decoder)
    }

    public func encode(to encoder: Encoder) throws {
        try value.encode(to: encoder)
    }
}
