//
//  THUXPageableModelManager.swift
//  LithoUXComponents
//
//  Created by Elliot Schrock on 10/6/19.
//

import Foundation

public protocol Pageable {
    func nextPage()
    func fetchPage(_ page: Int)
}

open class LUXPageableModelManager: LUXRefreshableNetworkCallManager, Pageable {
    public var page: Int {
        didSet {
            onPageUpdate?(page)
        }
    }
    private let firstPageValue: Int
    private var onPageUpdate: ((Int) -> Void)?
    
    public init(_ call: CombineNetCall, firstPageValue: Int = 0) {
        self.firstPageValue = firstPageValue
        self.page = firstPageValue
        super.init(call)
    }
    
    open func viewDidLoad() {
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
