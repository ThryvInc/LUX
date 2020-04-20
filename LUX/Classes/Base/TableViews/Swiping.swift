//
//  Swiping.swift
//  LUX
//
//  Created by Elliot Schrock on 4/20/20.
//

import FlexDataSource

public protocol Swipable {
    var onSwipe: () -> Void { get }
}

open class SwipableItem<T>: FunctionalFlexDataSourceItem<T>, Swipable where T: UITableViewCell {
    public var onSwipe: () -> Void
    
    public init(identifier: String,
                _ configureCell: @escaping (UITableViewCell) -> Void,
                _ onSwipe: @escaping () -> Void) {
        self.onSwipe = onSwipe
        super.init(identifier: identifier, configureCell)
    }
}

open class SwipableFlexDataSource: FlexDataSource {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if let _ = sections?[indexPath.section].items?[indexPath.row] as? Swipable {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let item = sections?[indexPath.section].items?[indexPath.row] as? Swipable {
                item.onSwipe()
                sections?[indexPath.section].items?.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
}
