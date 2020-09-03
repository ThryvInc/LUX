//
//  LUXDetailTableViewCell.swift
//  FunNet
//
//  Created by Elliot Schrock on 12/7/19.
//

import UIKit

open class LUXDetailTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
