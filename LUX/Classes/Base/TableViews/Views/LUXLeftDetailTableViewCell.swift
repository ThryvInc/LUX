//
//  LUXLeftDetailTableViewCell.swift
//  LUX
//
//  Created by Elliot Schrock on 4/6/20.
//

import UIKit

open class LUXLeftDetailTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value2, reuseIdentifier: reuseIdentifier)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
