//
//  LUXRefreshableTableViewDelegate.swift
//  ThryvUXComponents
//
//  Created by Elliot Schrock on 6/9/18.
//

import UIKit
import FlexDataSource

open class LUXFunctionalTableDelegate: NSObject, UITableViewDelegate {
    public var onSelect: (UITableView, IndexPath) -> Void = { _,_ in }
    public var onWillDisplay: (UITableViewCell, UITableView, IndexPath) -> Void = { _,_,_ in }
    
    @objc open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSelect(tableView, indexPath)
    }
    
    @objc open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        onWillDisplay(cell, tableView, indexPath)
    }
}

public extension FlexDataSource {
    func onSelect(_ tableView: UITableView, _ indexPath: IndexPath) -> Void {
        tableView.deselectRow(at: indexPath, animated: true)
        if let tappable = sections?[indexPath.section].items?[indexPath.row] as? Tappable {
            tappable.onTap()
        }
    }
}

public extension LUXPageableModelManager {
    func willDisplayFunction(pageSize: Int = 20, pageTrigger: Int = 5) -> (UITableViewCell, UITableView, IndexPath) -> Void {
        return { (cell: UITableViewCell, tableView: UITableView, indexPath: IndexPath) in
            let previousIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
            if tableView.indexPathsForVisibleRows?.contains(previousIndexPath) == true {
                let numberOfRows = tableView.numberOfRows(inSection: indexPath.section)
                if numberOfRows - indexPath.row == pageTrigger && numberOfRows % pageSize == 0  {
                    self.nextPage()
                }
            }
        }
    }
}
