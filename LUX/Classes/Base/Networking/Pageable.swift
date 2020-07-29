//
//  Pageable.swift
//  LUX
//
//  Created by Elliot Schrock on 4/9/20.
//

import Foundation

public protocol Pageable {
    func nextPage()
    func fetchPage(_ page: Int)
}
