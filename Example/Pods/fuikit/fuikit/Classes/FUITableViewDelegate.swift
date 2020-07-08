//
//  FUITableViewDelegate.swift
//  fuikit
//
//  Created by Elliot Schrock on 6/9/18.
//

import UIKit

open class FUITableViewDelegate: NSObject, UITableViewDelegate {
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
