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
    
    public init(onSelect: @escaping (UITableView, IndexPath) -> Void = { _,_ in },
                onWillDisplay: @escaping (UITableViewCell, UITableView, IndexPath) -> Void = { _,_,_ in }) {
        self.onSelect = onSelect
        self.onWillDisplay = onWillDisplay
    }
    
    @objc open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSelect(tableView, indexPath)
    }
    
    @objc open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        onWillDisplay(cell, tableView, indexPath)
    }
}

public extension FlexDataSource {
    func tappableOnSelect(_ tableView: UITableView, _ indexPath: IndexPath) -> Void {
        tableView.deselectRow(at: indexPath, animated: true)
        if let tappable = sections?[indexPath.section].items?[indexPath.row] as? Tappable {
            tappable.onTap()
        }
    }
    
    func itemTapOnSelect(onTap: @escaping (FlexDataSourceItem) -> Void) -> (UITableView, IndexPath) -> Void {
        return { tableView, indexPath in
            tableView.deselectRow(at: indexPath, animated: true)
            if let item = self.sections?[indexPath.section].items?[indexPath.row] {
                onTap(item)
            }
        }
    }
}
