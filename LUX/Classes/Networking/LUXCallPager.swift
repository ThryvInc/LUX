//
//  LUXCallPager.swift
//  LUX
//
//  Created by Elliot Schrock on 7/9/20.
//

import FunNet
import Slippers

open class LUXCallPager: Pager {
    open var call: Fireable?
    
    public init(pageKeyName: String = "page", countKeyName: String = "count", defaultCount: Int = 20, firstPageValue: Int = 0, _ call: CombineNetCall?) {
        self.call = call
        super.init(firstPageValue: firstPageValue, onPageUpdate: nil)
        self.onPageUpdate = { [unowned self] page in
            if let call = self.call as? CombineNetCall {
                call.endpoint.getParams.updateValue(page, forKey: pageKeyName)
                call.endpoint.getParams.updateValue(defaultCount, forKey: countKeyName)
            }
            self.call?.fire()
        }
    }
}
