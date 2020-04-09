//
//  LUXPageableModelManager.swift
//  LithoUXComponents
//
//  Created by Elliot Schrock on 10/6/19.
//

import FunNet

open class LUXPageableModelManager: LUXRefreshableNetworkCallManager, Pageable {
    public var page: Int {
        didSet {
            onPageUpdate?(page)
        }
    }
    private let firstPageValue: Int
    var onPageUpdate: ((Int) -> Void)?
    
    public init(_ call: CombineNetCall, firstPageValue: Int = 0) {
        self.firstPageValue = firstPageValue
        self.page = firstPageValue
        super.init(call)
        onPageUpdate = { page in
            if let call = self.call as? CombineNetCall {
                call.endpoint.getParams.updateValue(page, forKey: "page")
            }
            self.call?.fire()
        }
    }
    
    open override func refresh() {
        page = firstPageValue
    }
    
    open func nextPage() {
        page += 1
    }
    
    open func fetchPage(_ page: Int) {
        self.page = page
    }
}
