//
//  THUXRefreshableTableViewDelegate.swift
//  ThryvUXComponents
//
//  Created by Elliot Schrock on 6/9/18.
//

import UIKit
import MultiModelTableViewDataSource

open class LUXTappableTableDelegate: NSObject, UITableViewDelegate {
    public var onTap: (IndexPath) -> Void = { _ in }
    
    public init(_ onTap: ((IndexPath) -> Void)? = nil) {
        if let onTap = onTap {
            self.onTap = onTap
        }
    }
    
    public init(_ dataSource: MultiModelTableViewDataSource) {
        onTap = { indexPath in
            if let tappable = dataSource.sections?[indexPath.section].items?[indexPath.row] as? Tappable {
                tappable.onTap()
            }
        }
    }
    
    @objc open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        onTap(indexPath)
    }
}

open class LUXPageableTableViewDelegate: LUXTappableTableDelegate {
    open var pageableModelManager: LUXPageableModelManager?
    open var pageTrigger: Int = 5
    open var pageSize: Int = 20
    
    public init(_ pageableModelManager: LUXPageableModelManager?, _ onTap: ((IndexPath) -> Void)? = nil) {
        super.init(onTap)
        self.pageableModelManager = pageableModelManager
    }
    
    public init(_ pageableModelManager: LUXPageableModelManager?, _ dataSource: MultiModelTableViewDataSource) {
        super.init(dataSource)
        self.pageableModelManager = pageableModelManager
    }

    @objc open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let previousIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
        if tableView.indexPathsForVisibleRows?.contains(previousIndexPath) == true {
            let numberOfRows = tableView.numberOfRows(inSection: indexPath.section)
            if numberOfRows - indexPath.row == pageTrigger && numberOfRows % pageSize == 0  {
                pageableModelManager?.nextPage()
            }
        }
    }
}
