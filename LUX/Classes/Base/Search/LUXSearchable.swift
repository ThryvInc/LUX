//
//  LUXSearchable.swift
//  LUX
//
//  Created by Elliot Schrock on 11/11/20.
//

import FunNet
import Slippers

public protocol LUXSearchable {
    func updateIncrementalSearch(text: String?)
    func updateSearch(text: String?)
}

public func defaultOnSearch<T>(_ searcher: LUXSearchable, _ call: T, _ refresher: Refreshable? = nil, paramName: String = "query") -> (String) -> Void where T: NetworkCall & Fireable {
    return { text in
        searcher.updateSearch(text: text)
        call.endpoint.getParams.updateValue(text, forKey: paramName)
        if text.isEmpty {
            call.endpoint.getParams.removeValue(forKey: paramName)
        }
        if let refresher = refresher {
            refresher.refresh()
        } else {
            call.fire()
        }
    }
}
